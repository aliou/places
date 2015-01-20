class PlaceCreationJob < ActiveJob::Base
  queue_as :default

  # Public: Sets the foursquare venue URL of the Place.
  #
  # place - The Place to update.
  #
  # Returns nothing.
  def perform(place)
    client = Foursquare2::Client.new(
      oauth_token: place.user.oauth_token,
      api_version: Places::Application::FOURSQUARE_API_VERSION
    )

    place.foursquare_venue_url =
      client.venue(place.foursquare_venue_id)['shortUrl']
    place.save
  end
end
