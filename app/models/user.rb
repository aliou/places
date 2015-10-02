# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  name        :string
#  uid         :string
#  provider    :string
#  oauth_token :string
#  created_at  :datetime
#  updated_at  :datetime
#

class User < ActiveRecord::Base
  has_many :places
  has_many :identities
  has_one :place_importer, class_name: 'Place::Importer'

  after_create :initial_places_import

  # Find or create a new User depending on omniauth data.
  #
  # auth - The omniauth authentification details.
  #
  # Returns a User or nil.
  def self.from_omniauth(auth)
    identity = Identity.where(uid: auth['uid'], provider: auth[:provider], primary: true).first
    if identity.present?
      user = identity.user
    else
      User.create_from_omniauth(auth)
    end
  end

  # Create a user from its omniauth authentification details.
  #
  # auth - The omniauth authentification details.
  #
  # Returns a User or nil.
  def self.create_from_omniauth(auth)
    user = create!(name: (auth['info']['name'] || ''))
    user.identities.create!(
      primary: true,
      provider: auth['provider'],
      uid: auth['uid'],
      oauth_token: auth['credentials']['token'],
    )
    # create! do |user|
    #   user.provider     = auth['provider']
    #   user.uid          = auth['uid']
    #   user.oauth_token  = auth['credentials']['token']
    #
    #   if auth['info']
    #     user.name       = auth['info']['name'] || ''
    #   end
    # end
    return user
  rescue ActiveRecord::RecordInvalid
    if user and user.persisted?
      user.destroy!
    end
    return nil
  end

  # Get the user's primary identity.
  #
  # Returns an Identity or nil.
  def main_identity
    identities.where(primary: true).first
  end

  # Public: Import places from 4SQ.
  #
  # Returns an array of Places.
  def import_places
    create_place_importer if place_importer.nil?

    place_importer.run
  end

  private

  # Private: Run a job to import the places from Foursquare
  #
  # Returns: Nothing.
  def initial_places_import
    PlaceImportJob.perform_later(self)
  end
end
