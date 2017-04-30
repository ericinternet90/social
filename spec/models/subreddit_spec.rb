require 'rails_helper'

RSpec.describe Subreddit, type: :model do

  describe "associations" do
    it { should have_many(:fp_subreddits) }
    it { should have_many(:facebook_pages).through(:fp_subreddits) }
  end

end
