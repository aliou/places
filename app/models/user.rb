class User < ActiveRecord::Base

  ##############################################################################
  # Associations                                                               #
  ##############################################################################

  has_many :places

  ##############################################################################
  # Validations                                                                #
  ##############################################################################

  validates :uid         , presence: true
  validates :provider    , presence: true
  validates :oauth_token , presence: true
  validates :uid,          inclusion: { in: [ ENV['FOURSQUARE_USER_ID'] ],
                                        message: 'Unauthorized user.' }

  ##############################################################################
  # Class Methods                                                              #
  ##############################################################################

  # Find or create a new User depending on omniauth data.
  # TODO: Delay the place import.
  #
  # Returns the User.
  def self.find_or_create_with_omniauth(auth)
    if user = User.where(uid: auth['uid']).first
      user
    else
      user = User.create_with_omniauth(auth)
      user.import_places
    end

    user
  end

  # Create a user from its omniauth authentification details.
  #
  # auth - The omniauth authentification details.
  #
  # Returns the User.
  def self.create_with_omniauth(auth)
    create do |user|
      user.provider     = auth['provider']
      user.uid          = auth['uid']
      user.oauth_token  = auth['credentials']['token']

      if auth['info']
        user.name       = auth['info']['name'] || ''
      end
    end
  end

  ##############################################################################
  # Instance Methods                                                           #
  ##############################################################################

  # Public: Import places from 4SQ.
  #
  # Returns an array of Places.
  def import_places
    client = Foursquare2::Client.new oauth_token: self.oauth_token,
                                     api_version: '20140806'
    todo_list = client.list("#{self.uid}/todos", limit: 200)
    todos = todo_list['listItems']['items'].map do |item|
      Place.find_or_create_from_foursquare_venue(item, self)
    end

    todos
  end

end
