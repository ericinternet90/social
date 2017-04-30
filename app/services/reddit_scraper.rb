class RedditScraper < Scraper

  def initialize(options)
    setup_capybara
    @posts = []
    @subreddit = options.fetch(:subreddit)
    setup_page
  end

  def scrape
    set_posts
    @posts
  end

private

  def setup_page
    @browser.visit(@subreddit.url)
    wait_for_ajax
  end

  def add_post_if_valid(**attributes)
    post = RedditPost.new(**attributes)
    @posts << post if post.valid?
  end

  def set_posts
    link_containers.each do |link_container|
      @browser.within(link_container) do
        add_post_if_valid(
          text: @browser.find('a.title').text,
          link: @browser.find('a.title')[:href],
          rank: @browser.find('.rank').text.to_i
        )
      end
    end
  end

  def link_containers
    @links_nodes ||= @browser.all("div[data-type='link']")
  end

  def titles
    xpath = "//p[@class='title']//p//a"
    @browser.all(:xpath, xpath)#.map(&:text)
  end

end
