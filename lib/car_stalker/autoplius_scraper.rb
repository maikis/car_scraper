require 'capybara'
require 'capybara/poltergeist'

module CarStalker
  # Scraper class for Autoplius site.
  class AutopliusScraper
    attr_reader :starting_page, :session, :ad_link_xpath,
                :pagination_xpath_string, :all_pages, :visited_pages,
                :link_matcher, :pagination_ul_xpath

    def initialize
      # TODO: Find where to put configuration.
      Capybara.javascript_driver = :poltergeist
      @starting_page = 'http://en.autoplius.lt/search/used-cars'
      @ad_link_xpath = '//h2[@class="title-list"]/a/@href'
      @pagination_ul_xpath =
        '//div[@class="paging-panel paging-bot"]/ul[@class="paging"]'
      @pagination_xpath_string = "#{pagination_ul_xpath}/li/a/span"
      # For pagination.
      @all_pages = []
      @visited_pages = []
    end

    def get_links(car_specs)
      car_specs = CarStalker::Translator.translate(car_specs, :autoplius)
                    .fetch(:autoplius, {})
      # TODO: raise proper error when specs are missing.
      @link_matcher = car_specs[:make_id_list]
      scrape_with_pagination(main_page_html(car_specs))
    end

    private

    def session
      @session ||= Capybara::Session.new(:poltergeist)
    end

    def scrape_page(page_html)
      nokogiri_page = to_nokogiri_page(page_html)
      main_page_links = extract_links(nokogiri_page, ad_link_xpath)
      # Since make of the car (like BMW) is used in autoplius links, here we
      # are trying to discard the links which are not for BMW's, like
      # javascript added advertisements.
      cleanup_links(main_page_links, link_matcher)
    end

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

    def paginated_scrape(current_page_number, links)
      visit_next_pagination_page(current_page_number)
      update_visited_pages(current_page_number)
      renew_pagination_list
      links << scrape_page(session.html)
      paginated_scrape(all_pages.first, links) unless all_pages.empty?
      links.flatten
    end

    def visit_next_pagination_page(page_number)
      session.within(:xpath, pagination_ul_xpath) do
        session.click_on(page_number)
      end
      sleep(2)
    end

    def visit_search_form_page
      session.visit(starting_page)
      sleep(2)
    end

    def fill_in_search_form(car_specs)
      visit_search_form_page
      car_specs.each do |field, value|
        session.select(value.to_s, from: field.to_s)
      end
    end

    def update_visited_pages(current_page_number)
      @visited_pages << current_page_number
    end

    def renew_pagination_list
      nokogiri_page = to_nokogiri_page(session.html)
      @all_pages = page_numbers(nokogiri_page)
      @all_pages -= visited_pages
    end

    def page_numbers(nokogiri_page)
      nokogiri_page.xpath(pagination_xpath_string).map(&:text)
    end

    def to_nokogiri_page(html_page)
      Nokogiri::HTML(html_page)
    end

    def extract_links(nokogiri_page, link_xpath_string)
      nokogiri_page.xpath(link_xpath_string)
    end

    def cleanup_links(links, car_make)
      links.map(&:value)
           .uniq
           .reject { |link| !link.include?(car_make.to_s.downcase) }
    end
  end
end
