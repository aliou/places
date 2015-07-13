class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :uid
      t.string :provider
      t.string :oauth_token
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :identities, [:provider, :uid], unique: true
  end
end
