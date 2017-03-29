require 'phantomjs'
require 'capybara/poltergeist'

class Scraper

  def self.call(options = {})
    self.new(options).scrape
  end

private

  def setup_capybara
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, js_errors: false, phantomjs: Phantomjs.path)
    end
    Capybara.default_driver = :poltergeist
    @browser = Capybara.current_session
  end

  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until @browser.evaluate_script('jQuery.active').to_i == 0
    end
  end

end
