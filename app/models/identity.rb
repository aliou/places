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
  PROVIDERS = []

  belongs_to :user, dependent: :destroy
end
