class CreateUserPlaceImporters < ActiveRecord::Migration
  def change
    create_table :user_place_importers do |t|
      t.datetime   :last_imported_at
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
