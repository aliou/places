# == Schema Information
#
# Table name: attachments
#
#  id         :integer          not null, primary key
#  type       :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  place_id   :integer
#
# Indexes
#
#  index_attachments_on_place_id  (place_id)
#

class Attachment < ActiveRecord::Base

  ######################################################################
  # Constants                                                          #
  ######################################################################

  ATTACHMENT_TYPES = []

  ######################################################################
  # Macros                                                             #
  ######################################################################

  belongs_to :place

  ######################################################################
  # Validations                                                        #
  ######################################################################

  validates :url, presence: true

end
