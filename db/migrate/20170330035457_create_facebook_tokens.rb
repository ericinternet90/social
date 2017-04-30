class CreateFacebookTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :facebook_tokens do |t|
      t.references :user
      t.string :facebook_user_id, limit: 128
      t.string :access_token
      t.string :refresh_token
      t.integer :expires_in
      t.timestamps
    end
  end
end
