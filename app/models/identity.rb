# == Schema Information
#
# Table name: identities
#
#  id          :integer          not null, primary key
#  uid         :string
#  provider    :string
#  oauth_token :string
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_identities_on_provider_and_uid  (provider,uid) UNIQUE
#  index_identities_on_user_id           (user_id)
#

class Identity < ActiveRecord::Base
  PROVIDERS = [:foursquare]

  belongs_to :user, dependent: :destroy

  validates :provider, presence: true
  validates :oauth_token, presence: true
  validates :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }

  # Create an Identity from its omniauth authentification details.
  #
  # auth - The omniauth authentification details.
  #
  # Returns a User or nil.
  def self.create_from_auth(auth)
    create!(provider: auth['provider'], uid: auth['uid'],
           oauth_token: auth['credentials']['token'])
  rescue ActiveRecord::RecordInvalid
    return nil
  end

  # Find or create an Identity depending on the omniauth data.
  #
  # auth - The omniauth authentification details.
  #
  # Returns an Identity or nil
  def self.from_auth(auth)
    where(uid: auth['uid'], provider: auth['provider']).first ||
      create_from_auth(auth)
  end

  # The provider client authed with this identity credentials.
  #
  # Returns a Provider client, eg. `Foursquare2::Client`, etc.
  def client
    client_method = provider + '_client'
    return nil if !self.respond_to?(client_method, true)

    self.send(client_method)
  end

  private

  def foursquare_client
    @client ||= Foursquare2::Client.new(
      oauth_token: oauth_token,
      api_version: Places::Application::FOURSQUARE_API_VERSION
    )
  end
end
