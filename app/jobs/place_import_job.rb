class PlaceImportJob < ActiveJob::Base
  queue_as :default

  # Import the user's saved places from Foursquare.
  def perform(user)
    user.import_places
  end
end
