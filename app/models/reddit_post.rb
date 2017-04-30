class RedditPost
  include ActiveModel::Model
  WHITELISTED_HOSTS = [
    'i.imgur.com',
    'imgur.com',
    'i.redd.it',
    'gfycat.com',
    'pixel.redditmedia.com'
  ]

  attr_accessor :text, :link, :rank
  validates_presence_of :text, :link
  validates_inclusion_of :rank, in: 1..25

  validate do |reddit_post|
    unless reddit_post.whitelisted_link?
      errors.add(:base, "Link is not whitelisted: #{link}")
    end
  end

  def whitelisted_link?
    uri.scheme.in?(['http', 'https']) && uri.host.in?(WHITELISTED_HOSTS)
  end

  def uri
    URI.parse(link)
  end

end
