class RedditScraper < Scraper

  def initialize(options)
    setup_capybara
    @posts = []
    @sub = options[:sub] || 'GifRecipes'
    setup_page
  end

  def scrape
    set_posts
    @posts
  end

private

  def setup_page
    @browser.visit("https://www.reddit.com/r/#{@sub}/")
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

  def find_or_create_venues
    setup_page
    xpath = "//li[@class='flex-active-slide']//p//a"
    venue_names = @browser.all(:xpath, xpath).map(&:text) # todo filter/admin to exclude links to artists, etc-
    existing_venues = Venue.where(name: venue_names)
    @venues += existing_venues
    venue_names -= existing_venues.map(&:name)
    venue_names.each { |name| @venues << Venue.find_or_create_by(name: name) }
  end

  def find_or_create_events
    setup_page
    xpath = "//li[@class='flex-active-slide']//p"
    paragraphs = @browser.all(:xpath, xpath).map(&:text)
    paragraphs.each { |paragraph| create_event_maybe(paragraph) }
  end

  def create_event_maybe(paragraph)
    Venue.open_pluck(:id, :name).each do |venue|
      if Regexp.new(venue.name).match(paragraph)
        @events << Event.find_or_create_by(
          venue_id: venue.id,
          description: paragraph,
          date: @date
        )
      end
    end
  end

end
