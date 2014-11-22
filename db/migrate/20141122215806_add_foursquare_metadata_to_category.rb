class AddFoursquareMetadataToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :metadata, :hstore
  end
end
