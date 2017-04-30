class CreateFpSubreddits < ActiveRecord::Migration[5.0]
  def change
    create_table :fp_subreddits do |t|
      t.references :subreddit
      t.references :facebook_page
      t.timestamps
    end
  end
end
