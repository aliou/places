class AddStarredToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :starred, :boolean, default: false
  end
end
