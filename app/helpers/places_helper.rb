module PlacesHelper
  # Public: Get the primary category for a Foursquare venue.
  #
  # venue - The Foursquare venue.
  #
  # Returns a Category or nil.
  def venue_primary_category(venue)
    category = venue['venue']['categories'].find { |cat| cat['primary'] }

    Category.from_foursquare(category)
  end
end
