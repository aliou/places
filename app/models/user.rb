class User < ActiveRecord::Base
  validates :uid         , presence: true
  validates :provider    , presence: true
  validates :oauth_token , presence: true

  validates :uid, inclusion: { in: [ ENV['FOURSQUARE_USER_ID'] ] ,
                               message: 'Unauthorized user.' }

  # Find or create a new User depending on omniauth data.
  #
  # Returns the User.
  def self.find_or_create_with_omniauth(auth)
    if user = User.where(uid: auth['uid']).first
      user
    else
      self.create_with_omniauth(auth)
    end
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
end
