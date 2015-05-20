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
  ##############################################################################
  # Associations                                                               #
  ##############################################################################

  has_many :places
  has_one :place_importer

  ##############################################################################
  # Validations                                                                #
  ##############################################################################

  validates :provider,    presence: true
  validates :oauth_token, presence: true

  validates :uid, presence: true, uniqueness: true, inclusion: {
    in:      ENV.fetch('FOURSQUARE_USER_ID').split(','),
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
  # Returns a User or nil.
  def self.from_omniauth(auth)
    User.where(uid: auth['uid']).first || User.create_from_omniauth(auth)
  end

  # Create a user from its omniauth authentification details.
  #
  # auth - The omniauth authentification details.
  #
  # Returns a User or nil.
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
