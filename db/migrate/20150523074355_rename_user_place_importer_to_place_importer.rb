class RenameUserPlaceImporterToPlaceImporter < ActiveRecord::Migration
  def change
    rename_table :user_place_importers, :place_importers
  end
end
