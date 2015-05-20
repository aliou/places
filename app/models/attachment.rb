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
  validates :url, uniqueness: { scope: :place_id }

  ######################################################################
  # Methods                                                            #
  ######################################################################

  # Public: The thumbnail URL for the attachment.
  #
  # Raises Errors::NotImplementedError since this method must be implemented in
  # the child classes.
  def thumbnail_url
    raise Errors::NotImplementedError
  end
end
