class CreateFacebookPages < ActiveRecord::Migration[5.0]
  def change
    create_table :facebook_pages do |t|
      t.references :user
      t.string :facebook_page_id, limit: 256, null: false
      t.string :name, limit: 128, null: false
      t.string :category, limit: 128, null: false
      t.timestamps
    end
  end
end
