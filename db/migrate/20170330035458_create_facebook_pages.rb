class CreateFacebookPages < ActiveRecord::Migration[5.0]
  def change
    create_table :facebook_pages do |t|
      t.references :user
      t.string :facebook_page_id, limit: 256, null: false
      t.string :name, limit: 256, null: false
      t.boolean :enabled, default: true
      t.timestamps
    end
  end
end
