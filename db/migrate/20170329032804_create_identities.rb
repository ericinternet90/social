class CreateIdentities < ActiveRecord::Migration[5.0]
  def change
    create_table :identities do |t|
      t.belongs_to :user, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps null: false
    end
  end
end
