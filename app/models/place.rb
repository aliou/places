# == Schema Information
#
# Table name: places
#
#  id                   :integer          not null, primary key
#  name                 :string
#  lat                  :float
#  lng                  :float
#  notes                :text
#  created_at           :datetime
#  updated_at           :datetime
#  user_id              :integer
#  foursquare_venue_id  :string
#  address              :string
#  metadata             :hstore
#  category_id          :integer
#  slug                 :string
#  foursquare_venue_url :string
#  starred              :boolean          default(FALSE)
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
  include MapboxHelper

  ##############################################################################
  #                                                                            #
  ##############################################################################

  store_accessor :metadata, :foursquare_data, :starred

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

  acts_as_mappable lat_column_name: :lat,
    lng_column_name: :lng

  friendly_id :name, use: [:slugged, :finders]

  ##############################################################################
  # Class Methods                                                              #
  ##############################################################################

  # Public: Finds or creates a new Place from a Foursquare venue.
  #
  # venue - The Foursquare Venue to find or create as a Place.
  # user  - The user to attribute the Place to.
  #
  # Returns a Place or nil.
  def self.from_foursquare(venue, user)
    venue_id = venue['id'].starts_with?('v') ? venue['id'][1..-1] : venue['id']

    Place.where(foursquare_venue_id: venue_id).first ||
      Place.create_from_foursquare(venue, user)
  end

  # Public: Creates a new Place from a Foursquare venue.
  #
  # venue - The Foursquare Venue to find or create as a Place.
  # user  - The user to attribute the Place to.
  #
  # Returns a Place or nil.
  def self.create_from_foursquare(venue, user)
    venue_data = venue['venue']
    create! do |place|
      place.user = user

      place.foursquare_venue_id = stripped_venue_id(venue['id'])

      place.name    = venue_data['name']
      place.lat     = venue_data['location']['lat']
      place.lng     = venue_data['location']['lng']
      place.address = venue_data['location']['formattedAddress'].join(', ')

      place.category = venue_primary_category(venue)

      place.foursquare_data = venue.to_json
    end
  rescue ActiveRecord::RecordInvalid
    return nil
  end

  # Public: Gets the Places in the same zoom level radius as self.
  # TODO: Might be better to also return self.
  #
  # zoom_level - The zoom level to search the place in.
  #              (default: 16, Neighborhood)
  #
  # Returns an Araay of Places.
  def places_around(zoom_level = MapboxHelper::NEIGHBORHOOD_LEVEL_ZOOM)
    Place.within(zoom_to_radius(zoom_level, lat), origin: self) - [self]
  end

  private

  # Private: Set the Foursquare URL
  #
  # Returns nothing
  def set_foursquare_venue_url
    PlaceCreationJob.perform_later(self)
  end
end
