class AddMetadataToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :address, :string
    add_column :places, :category, :string
  end
end
