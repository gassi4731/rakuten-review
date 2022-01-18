require 'selenium-webdriver'

class RakutenReviewManager
  def initialize(review_url)
    @review_url = review_url
    @wait_time = 3
    @timeout = 4
    Selenium::WebDriver.logger.output = File.join("./", "selenium.log")
    Selenium::WebDriver.logger.level = :warn
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    @driver = Selenium::WebDriver.for :chrome, options: options
    @driver.manage.timeouts.implicit_wait = @timeout
    wait = Selenium::WebDriver::Wait.new(timeout: @wait_time)
  end

  def quit
    @driver.quit
  end

  def getAllReviews
    reviews = []
    i = 1
    while i <= 100 do
      onePageReviews = getReviews(i.to_s + '.1')
      if onePageReviews.length != 0
        reviews = reviews + onePageReviews
        i += 1
      else
        break
      end
    end
    return reviews
  end

  def getReviews(page_id)
    @driver.get(@review_url + '/' + page_id + '/')
    sleep 1
    reviews = []
    elements = @driver.find_elements(:class, 'revRvwUserSec')
    elements.each do |element|
      star = element.find_element(:class, 'value').text
      description = element.find_element(:class, 'description').text.gsub(/\n/, ' ')
      reviews.push([star, description])
    end
    puts 'get: ' + @review_url + '/' + page_id + '/'
    return reviews
  end
end