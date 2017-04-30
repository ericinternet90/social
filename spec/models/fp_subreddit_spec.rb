require 'rails_helper'

RSpec.describe FpSubreddit, type: :model do

  describe "associations" do
    it { should belong_to(:facebook_page) }
    it { should belong_to(:subreddit) }
  end

end
