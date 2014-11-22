# == Schema Information
#
# Table name: places
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  lat                 :float
#  lng                 :float
#  notes               :text
#  created_at          :datetime
#  updated_at          :datetime
#  user_id             :integer
#  foursquare_venue_id :string(255)
#  address             :string(255)
#  metadata            :hstore
#  category_id         :integer
#
# Indexes
#
#  index_places_on_category_id  (category_id)
#  index_places_on_user_id      (user_id)
#

class Place < ActiveRecord::Base
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
  validates :lat ,                presence: true
  validates :lng ,                presence: true
  validates :foursquare_venue_id, presence: true

  validates :foursquare_venue_id, uniqueness: { scope: :user_id }

  ##############################################################################
  # Macros                                                                     #
  ##############################################################################

  acts_as_mappable :default_units => :kms,
                 :lat_column_name => :lat,
                 :lng_column_name => :lng

  ##############################################################################
  # Class Methods                                                              #
  ##############################################################################

  # Public: Finds or creates a new Place from a Foursquare venue.
  #
  # Returns the found or created Place.
  def self.find_or_create_from_foursquare_venue(venue, user = current_user)
    place = Place.where(foursquare_venue_id: venue['id']).first
    if place.nil?
      place = Place.create_from_foursquare_venue(venue, user)
    end

    place
  end

  # Public: Creates a new Place from a Foursquare venue.
  #
  # Returns the created Place.
  def self.create_from_foursquare_venue(venue, user = current_user)
    create do |place|
      place.user_id             = user.id
      place.foursquare_venue_id = venue['id']

      place.name                = venue['venue']['name']
      place.lat                 = venue['venue']['location']['lat']
      place.lng                 = venue['venue']['location']['lng']

      place.category            = venue_primary_category(venue)

      place.foursquare_data     = venue.to_json
    end
  end
end
