class AddFoursquareUrlToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :foursquare_venue_url, :string
  end
end
