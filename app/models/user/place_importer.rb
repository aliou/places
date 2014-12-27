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
end
