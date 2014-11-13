class AddFoursquareMetadataToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :metadata, :hstore
  end
end
