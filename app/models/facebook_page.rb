# == Schema Information
#
# Table name: facebook_pages
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  facebook_page_id :string(256)      not null
#  name             :string(128)      not null
#  category         :string(128)      not null
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
  end

  def graph
    raise "Nonexistent token for faceboook_page #{id}" unless token
    raise "Expired token for faceboook_page #{id}" if token.expired?
    @graph ||= token.graph
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

end
