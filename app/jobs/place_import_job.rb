class PlaceImportJob < ActiveJob::Base
  queue_as :default

  # Public: Import the user's saved places from Foursquare.
  #
  # user - The user to import the places from.
  #
  # Returns nothing.
  def perform(user)
    user.import_places
  end
end
