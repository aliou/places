class RemoveOauthSecreteColumnFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :oauth_secret
  end
end
