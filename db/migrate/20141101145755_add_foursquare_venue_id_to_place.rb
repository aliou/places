class AddFoursquareVenueIdToPlace < ActiveRecord::Migration
  def change
    add_column :places, :foursquare_venue_id, :string
  end
end
