require 'capybara'
require 'capybara/poltergeist'

module CarStalker
  # Scraper class for Autogidas site.
  class AutogidasScraper
    attr_reader :starting_page, :pagination_xpath_string

    def initialize
      Capybara.javascript_driver = :poltergeist
      @starting_page = 'http://en.autogidas.lt/paieska/automobiliai/'
      @pagination_xpath_string = ''
    end

    def get_links(car_specs)
      car_specs = CarStalker::Translator.translate(car_specs).fetch(:autogidas)
      scrape_with_pagination(main_page_html(car_specs))
    end

    private

    def main_page_html(car_specs)
      fill_in_search_form(car_specs)
      session.click_on('Search')
      session.html
    end

    def scrape_with_pagination(main_page_html)
      nokogiri_page = to_nokogiri_page(main_page_html)
      @all_pages = page_numbers(nokogiri_page)
      # Sometimes we have only few results and no pagination...
      return scrape_page(main_page_html) if all_pages.empty?
      paginated_scrape(all_pages.first, [])
    end

    def fill_in_search_form(car_specs)
      visit_search_form_page
      car_specs.each do |field, value|
        session.select(value.to_s, from: field.to_s)
      end
    end

    def visit_search_form_page
      session.visit(starting_page)
      sleep(2)
    end

    def to_nokogiri_page(html_page)
      Nokogiri::HTML(html_page)
    end

    def page_numbers(nokogiri_page)
      nokogiri_page.xpath(pagination_xpath_string).map(&:text)
    end
  end
end
