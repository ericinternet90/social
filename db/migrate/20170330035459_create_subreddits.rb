class CreateSubreddits < ActiveRecord::Migration[5.0]
  def change
    create_table :subreddits do |t|
      t.string :name, limit: 128, null: false
      t.timestamps
    end
    add_index :subreddits, :name, unique: true
  end
end
