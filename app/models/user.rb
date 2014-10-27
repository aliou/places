class User < ActiveRecord::Base
  validates :uid         , presence: true
  validates :provider    , presence: true
  validates :oauth_token , presence: true

  validates :uid, inclusion: { in: [ ENV['FOURSQUARE_USER_IDS'] ] ,
                               message: 'Unauthorized user.' }

  # Create a user from its omniauth authentification details.
  #
  # auth - The omniauth authentification details.
  #
  # Returns self.
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
