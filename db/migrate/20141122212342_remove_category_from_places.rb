class RemoveCategoryFromPlaces < ActiveRecord::Migration
  def change
    remove_column :places, :category
  end
end
