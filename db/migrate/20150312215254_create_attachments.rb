class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :type
      t.string :url

      t.timestamps null: false
    end
  end
end
