require 'rails_helper'

RSpec.describe FacebookPage, type: :model do

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:fp_subreddits) }
    it { should have_many(:subreddits).through(:fp_subreddits) }
  end

end
