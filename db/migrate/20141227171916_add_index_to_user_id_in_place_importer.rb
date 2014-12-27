class AddIndexToUserIdInPlaceImporter < ActiveRecord::Migration
  def change
    add_index :user_place_importers, :user_id
  end
end
