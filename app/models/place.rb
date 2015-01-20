# == Schema Information
#
# Table name: places
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  lat                  :float
#  lng                  :float
#  notes                :text
#  created_at           :datetime
#  updated_at           :datetime
#  user_id              :integer
#  foursquare_venue_id  :string(255)
#  address              :string(255)
#  metadata             :hstore
#  category_id          :integer
#  slug                 :string
#  foursquare_venue_url :string
#
# Indexes
#
#  index_places_on_category_id  (category_id)
#  index_places_on_slug         (slug) UNIQUE
#  index_places_on_user_id      (user_id)
#

class Place < ActiveRecord::Base
  extend FriendlyId
  extend PlacesHelper

  ##############################################################################
  #                                                                            #
  ##############################################################################
  store_accessor :metadata, :foursquare_data

  ##############################################################################
  # Associations                                                               #
  ##############################################################################

  belongs_to :user
  belongs_to :category

  ##############################################################################
  # Validations                                                                #
  ##############################################################################

  validates :name,                presence: true
  validates :lat,                 presence: true
  validates :lng,                 presence: true
  validates :foursquare_venue_id, presence: true

  validates :foursquare_venue_id, uniqueness: { scope: :user_id }

  ##############################################################################
  # Callbacks                                                                  #
  ##############################################################################

  after_create :set_foursquare_venue_url

  ##############################################################################
  # Macros                                                                     #
  ##############################################################################

  acts_as_mappable :default_units => :kms,
                 :lat_column_name => :lat,
                 :lng_column_name => :lng

  friendly_id :name, use: [:slugged, :finders]

  ##############################################################################
  # Class Methods                                                              #
  ##############################################################################

  # Public: Finds or creates a new Place from a Foursquare venue.
  #
  # Returns a Place or nil.
  def self.from_foursquare(venue, user = current_user)
    Place.where(foursquare_venue_id: venue['id']).first ||
      Place.create_from_foursquare(venue, user)
  end

  # Public: Creates a new Place from a Foursquare venue.
  #
  # Returns a Place or nil.
  def self.create_from_foursquare(venue, user = current_user)
    create! do |place|
      place.user_id                = user.id

      if venue['id'].starts_with?('v')
        place.foursquare_venue_id  = venue['id'][1..-1]
      else
        place.foursquare_venue_id  = venue['id']
      end

      place.name                   = venue['venue']['name']
      place.lat                    = venue['venue']['location']['lat']
      place.lng                    = venue['venue']['location']['lng']

      place.category               = venue_primary_category(venue)

      place.foursquare_data        = venue.to_json
    end
  rescue ActiveRecord::RecordInvalid
    return nil
  end

  private

  # Private: Set the Foursquare URL
  # TODO: Do this in a Job.
  # TODO: Call after_create.
  # TODO: DRY the client creation (already exists in User::PlaceImporter)
  #
  # Returns nothing
  def set_foursquare_venue_url
    client = Foursquare2::Client.new(
      oauth_token: self.user.oauth_token,
      api_version: Places::Application::FOURSQUARE_API_VERSION
    )

    self.foursquare_venue_url = client.venue(self.foursquare_venue_id)['shortUrl']
    self.save
  end
end
