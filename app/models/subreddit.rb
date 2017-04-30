# == Schema Information
#
# Table name: subreddits
#
#  id         :integer          not null, primary key
#  name       :string(128)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_subreddits_on_name  (name) UNIQUE
#

class Subreddit < ApplicationRecord
  validates_presence_of :name

  def url
    "https://www.reddit.com/r/#{name}"
  end

  def posts
    RedditScraper.call(subreddit: self)
  end
end
