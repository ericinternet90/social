# == Schema Information
#
# Table name: facebook_tokens
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  facebook_user_id :string(128)
#  access_token     :string
#  refresh_token    :string
#  expires_in       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_facebook_tokens_on_user_id  (user_id)
#

class FacebookToken < ApplicationRecord
  before_save :set_facebook_user_id, unless: Proc.new { |token| token.facebook_user_id.present? }
  SCOPE = 'email, manage_pages, publish_pages, read_insights'

  belongs_to :user

  def graph
    @graph ||= Koala::Facebook::API.new(access_token)
  end

  def pages
    graph.get_connections(facebook_user_id, "accounts")
  end

  def expired?
    DateTime.now > expires_at
  end

  def expires_at
    created_at + expires_in.seconds
  end

private

  def set_facebook_user_id
    self.facebook_user_id = graph.get_object("me")['id']
  end

end
