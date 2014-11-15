module PlacesHelper
  def venue_primary_category(venue)
    category = venue['venue']['categories'].find { |cat| cat['primary'] }
    category['name']
  end
end
