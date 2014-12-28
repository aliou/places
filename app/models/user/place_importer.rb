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

  private

  # Private: Get or create the foursquare client.
  #
  # Returns a Foursquare2::Client.
  def foursquare_client
    @client ||= Foursquare2::Client.new(
      oauth_token: user.oauth_token,
      api_version: '20140806'
    )
  end
end
