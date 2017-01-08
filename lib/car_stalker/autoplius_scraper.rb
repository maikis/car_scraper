require 'capybara'
require 'capybara/poltergeist'

module CarStalker
  # Scraper class for Autoplius site.
  class AutopliusScraper
    attr_reader :starting_page, :session, :ad_link_xpath

    def initialize
      Capybara.javascript_driver = :poltergeist
      @starting_page = 'http://autoplius.lt/paieska/naudoti-automobiliai'
      @ad_link_xpath = '//h2[@class="title-list"]/a/@href'
    end

    def get_links(car_specs)
      scrape_result = scrape_ads(car_specs)
      links = extract_links(scrape_result, ad_link_xpath)
      cleanup_links(links, car_specs.fetch(:make_id_list, '-'))
    end

    private

    def session
      @session ||= Capybara::Session.new(:poltergeist)
    end

    def scrape_ads(car_specs)
      session.visit(starting_page)
      sleep(1)
      car_specs.each do |field, value|
        session.select(value.to_s, from: field.to_s)
      end
      session.click_on('Ieškoti')
      session.html
    end

    def extract_links(page_html, link_xpath_string)
      nokogiri_page = Nokogiri::HTML(page_html)
      nokogiri_page.xpath(link_xpath_string)
    end

    def cleanup_links(links, car_make)
      links.map(&:value)
           .uniq
           .reject { |link| !link.include?(car_make.downcase) }
    end
  end
end
