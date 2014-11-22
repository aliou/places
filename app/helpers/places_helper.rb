module PlacesHelper
  def venue_primary_category(venue)
    category = venue['venue']['categories'].find { |cat| cat['primary'] }

    Category.find_or_create_from_foursquare_category(category)
  end
end
