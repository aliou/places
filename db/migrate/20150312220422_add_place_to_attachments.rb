class AddPlaceToAttachments < ActiveRecord::Migration
  def change
    add_reference :attachments, :place, index: true
    add_foreign_key :attachments, :places
  end
end
