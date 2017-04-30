class FacebookPoster

  def self.call(options = {})
    self.new(options).call
  end

  def initialize(facebook_page_id:, post_details:)
    @facebook_page = FacebookPage.find_by!(
      facebook_page_id: facebook_page_id
    )

    @message = post_details.fetch(:message)
    @picture_url = post_details.fetch(:picture_url)
    @link_url = post_details.fetch(:link_url)
  end

  def call
    if !@facebook_page.enabled?
      Rails.logger.debug "FacebookPoster: not posting for disabled page #{@facebook_page.id}"
      return
    else
      create_post
      publish_post
    end
  end

  def create_post
    response = @facebook_page.graph.put_connections(
      @facebook_page.facebook_page_id,
      'feed',
      message: @message,
      picture: @picture_url,
      link: @link_url,
      published: true
    )

    @post_id = response.fetch('id')
  end

  def publish_post
    query_string = {
      is_published: true,
      access_token: @facebook_page.access_token
    }.to_query

    HTTParty.post(
      "https://graph.facebook.com/#{@post_id}?#{query_string}"
    )
  end

end
