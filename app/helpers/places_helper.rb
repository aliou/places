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


  # Public: Return the venue_id stripped from its prefix, if the prefix is
  # present.
  #
  # venue_id - The venue_id to be stripped.
  # prefix   - The prefix to strip.
  #
  # Returns a String, the venue_id without the prefix.
  def stripped_venue_id(venue_id, prefix = 'v')
    if venue_id.starts_with?(prefix)
      venue_id[prefix.length..-1]
    else
      venue_id
    end
  end
end
