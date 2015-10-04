class AddPrimaryToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :primary, :boolean, default: false
  end
end
