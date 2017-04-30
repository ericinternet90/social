class FacebookPostJob < ApplicationJob

  def perform(facebook_page_id:, subreddit_id:)
    @subreddit = Subreddit.find_by!(id: subreddit_id)

    FacebookPoster.call(
      facebook_page_id: facebook_page_id,
      post_details: post_details
    )
  end

private

  def reddit_posts
    @reddit_posts ||= ::RedditScraper.call(subreddit: @subreddit)
  end

  def top_post
    @top_post ||= reddit_posts.first
  end

  def post_details
    @post_details ||= {
      message: top_post.text,
      link_url: top_post.link,
      picture_url: top_post.link
    }
  end

end
