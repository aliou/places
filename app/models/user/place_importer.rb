# == Schema Information
#
# Table name: user_place_importers
#
#  id               :integer          not null, primary key
#  last_imported_at :datetime
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_user_place_importers_on_user_id  (user_id)
#

class User::PlaceImporter < ActiveRecord::Base
  ##############################################################################
  # Associations                                                               #
  ##############################################################################

  belongs_to :user

  ##############################################################################
  # Instance Methods                                                           #
  ##############################################################################

  # Public: Check if this is the first import perform by this object.
  #
  # Returns a Boolean.
  def first_import?
    last_imported_at.nil?
  end

  # Public: Runs the import and return the new Places.
  #
  # options - The Hash options.
  #           :limit  - The number of places to import (default: 200)
  #           :offset - The offset to start the import from (default: 0)
  #
  # Returns an Array of Places.
  def run(options = { limit: 200, offset: 0 })
    if first_import?
      first_run(options)
    else
      import(options)
    end
  end

  private

  # Private: Run the import for the first time.
  #
  # options - The Hash options.
  #           :limit  - The number of places to import (default: 200)
  #           :offset - The offset to start the import from (default: 0)
  #
  # Returns an Array of Places.
  def first_run(options)
    place_count = foursquare_client.list(foursquare_list)['listItems']['count']
    pages       = (place_count.to_f / options[:limit]).ceil

    places = pages.times.flat_map do |page|
      import(limit: options[:limit], offset: page * options[:limit])
    end

    self.last_imported_at = Time.now
    self.save

    places
  end

  # Private: Does the actual import.
  #
  # Returns an Array of places
  def import(options)
    list = foursquare_client.list(foursquare_list, options)['listItems']['items']

    list.map do |item|
      Place.from_foursquare(item, user)
    end
  end

  # Private: Get or create the foursquare client.
  #
  # Returns a Foursquare2::Client.
  def foursquare_client
    @client ||= Foursquare2::Client.new(
      oauth_token: user.oauth_token,
      api_version: '20140806'
    )
  end

  # Private: The Foursquare list to import from.
  #
  # Returns a String.
  def foursquare_list
    "#{user.uid}/todos"
  end
end
