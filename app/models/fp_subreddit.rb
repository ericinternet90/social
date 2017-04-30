# == Schema Information
#
# Table name: fp_subreddits
#
#  id               :integer          not null, primary key
#  subreddit_id     :integer
#  facebook_page_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_fp_subreddits_on_facebook_page_id  (facebook_page_id)
#  index_fp_subreddits_on_subreddit_id      (subreddit_id)
#

class FpSubreddit < ApplicationRecord
  belongs_to :facebook_page
  belongs_to :subreddit
end
