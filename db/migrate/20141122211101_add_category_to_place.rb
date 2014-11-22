class AddCategoryToPlace < ActiveRecord::Migration
  def change
    add_reference :places, :category, index: true
  end
end
