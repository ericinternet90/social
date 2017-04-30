# == Schema Information
#
# Table name: facebook_pages
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  facebook_page_id :string(256)      not null
#  name             :string(256)      not null
#  enabled          :boolean          default("true")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_facebook_pages_on_user_id  (user_id)
#

class FacebookPage < ApplicationRecord
  belongs_to :user

  def token
    @token ||= user.facebook_tokens.last
    raise "Nonexistent token for faceboook_page #{id}" unless @token
    raise "Expired token for faceboook_page #{id}" if @token.expired?
    @token
  end

  def graph
    @graph ||= Koala::Facebook::API.new(access_token)
  end

  def likes
    # TODO: fix
    result = graph.get_connections(facebook_page_id, 'insights', metric: 'page_fans', period: 'lifetime')
    values = result[0]["values"]
    latest_like_count = values.last['value']
  end

  def url
    'https://facebook.com/' + facebook_page_id
  end

  def access_token
    @access_token ||= token.graph.get_page_access_token(facebook_page_id)
  end

end
