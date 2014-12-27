# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  uid         :string(255)
#  provider    :string(255)
#  oauth_token :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class User < ActiveRecord::Base

  ##############################################################################
  # Associations                                                               #
  ##############################################################################

  has_many :places

  ##############################################################################
  # Validations                                                                #
  ##############################################################################

  validates :provider,    presence: true
  validates :oauth_token, presence: true

  validates :uid, presence: true, uniqueness: true, inclusion: {
    in:      [ENV['FOURSQUARE_USER_ID']],
    message: 'Unauthorized user.' }

  ##############################################################################
  # Callbacks                                                                  #
  ##############################################################################

  after_create :initial_places_import

  ##############################################################################
  # Class Methods                                                              #
  ##############################################################################

  # Find or create a new User depending on omniauth data.
  #
  # auth - The omniauth authentification details.
  #
  # Returns the User.
  def self.from_omniauth(auth)
    User.where(uid: auth['uid']).first || User.create_from_omniauth(auth)
  end

  # Create a user from its omniauth authentification details.
  #
  # auth - The omniauth authentification details.
  #
  # Returns the User.
  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider     = auth['provider']
      user.uid          = auth['uid']
      user.oauth_token  = auth['credentials']['token']

      if auth['info']
        user.name       = auth['info']['name'] || ''
      end
    end
  rescue ActiveRecord::RecordInvalid
    return nil
  end

  ##############################################################################
  # Instance Methods                                                           #
  ##############################################################################

  # Public: Import places from 4SQ.
  # TODO: Only import the new Places since last import.
  # TODO: Check pagination (limit of 200 per page).
  # TODO: Only return the new imported places.
  #
  # Returns an array of Places.
  def import_places(limit = 200)
    client = Foursquare2::Client.new oauth_token: self.oauth_token,
                                     api_version: '20140806'
    todo_list = client.list("#{self.uid}/todos", limit: limit)
    todos = todo_list['listItems']['items'].map do |item|
      Place.find_or_create_from_foursquare_venue(item, self)
    end

    todos
  end

  private

  # Private: Run a job to import the places from Foursquare
  #
  # Returns: Nothing.
  def initial_places_import
    PlaceImportJob.perform_later(self)
  end
end
