# The PlaceFilterer class only filters the places by their distance to the
# origin and the map zoom.
class PlaceFilterer
  include MapHelper
  attr_accessor :origin, :zoom

  def initialize(filters, user)
    @origin = filters.fetch(:origin, nil)
    @zoom   = filters.fetch(:zoom, nil)
    @user   = user
  end

  # The Filtered places
  #
  # Returns an array of Places.
  def places
    return @user.places if @origin.nil? or @zoom.nil?

    @user.places.within(radius, origin: @origin)
  end

  private

  # The radius around the origin we want the filtered places to be in.
  #
  # Returns a float.
  def radius
    zoom_to_radius(@zoom.to_f, @origin.first.to_f)
  end
end
