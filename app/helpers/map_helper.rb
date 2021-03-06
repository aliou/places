# Public: Methods to help dealing with MapBox values.
module MapHelper
  # Zoom levels.
  WORLD_LEVEL_ZOOM        = 0
  COUNTRY_LEVEL_ZOOM      = 9
  TOWN_LEVEL_ZOOM         = 13
  NEIGHBORHOOD_LEVEL_ZOOM = 16

  # The earth equatorial circumference in kms.
  EARTH_CIRCUMFERENCE = 40_075.017

  # The default radius of the circle we want the search in in pixels.
  SEARCH_RADIUS = 400

  # Public: Converts MapBox zoom value to kms.
  #
  # According to <http://wiki.openstreetmap.org/wiki/Zoom_levels>,
  # to get the distance represented by one pixel, we use the following equation:
  #
  # distance_for_one_px = earth_circumference * cos(latitude) / 2 ^ ( zoom + 8 )
  #
  # So to get the radius of the area we want the search to be in, we just
  # multiply the distance by the search radius.
  #
  # zoom_value    - The value to convert.
  # latitude      - Latitude of where the convertion is happening.
  # search_radius - The default radius we want the search in in pixels.
  #                 (default: SEARCH_RADIUS)
  #
  # Returns a Float.
  def zoom_to_radius(zoom_value, latitude, search_radius = SEARCH_RADIUS)
    search_radius * EARTH_CIRCUMFERENCE *
      Math::cos(degrees_to_radians(latitude)) / 2**(zoom_value + 8)
  end

  # Public: Converts an angle in degrees to radians.
  #
  # angle - The angle to convert.
  #
  # Returns a Float.
  def degrees_to_radians(angle)
    angle * Math::PI / 180
  end
end
