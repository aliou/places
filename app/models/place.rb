class Place < ActiveRecord::Base
  ##############################################################################
  #                                                                            #
  ##############################################################################
  store_accessor :metadata, :foursquare_data

  ##############################################################################
  # Associations                                                               #
  ##############################################################################

  belongs_to :user

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
    if place = Place.where(foursquare_venue_id: venue['id']).first
      place
    else
      place = Place.create_from_foursquare_venue(venue, user)
    end

    place
  end

  # Public: Creates a new Place from a Foursquare venue.
  #
  # Returns the created Place.
  def self.create_from_foursquare_venue(venue, user = current_user)
    create do |place|
      place.name                = venue['venue']['name']
      place.lat                 = venue['venue']['location']['lat']
      place.lng                 = venue['venue']['location']['lng']
      place.foursquare_venue_id = venue['id']
      place.user_id             = user.id
    end
  end
end
