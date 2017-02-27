require 'mechanize'

module CarStalker
  # Scraper class for Autogidas site.
  class AutogidasScraper
    attr_reader :starting_page_url, :mechanic, :search_page, :search_form,
                :link_xpath_string, :base_page_url

    def initialize
      @base_page_url = 'http://www.autogidas.lt'
      @starting_page_url = 'http://en.autogidas.lt/paieska/automobiliai/'
      @link_xpath_string =
        '//div[@class="all-ads-block"]/a[@class="item-link"]/@href'
      @mechanic = Mechanize.new
    end

    def get_links(car_specs)
      translated_specs = CarStalker::Translator
                         .translate(car_specs)
                         .fetch(:autogidas)
      scrape_results(translated_specs)
    end

    private

    def search_page
      @search_page ||= mechanic.get(starting_page_url)
    end

    def search_form
      @search_form ||= search_page.form_with(id: 'submit-form')
    end

    def scrape_results(translated_specs)
      fill_in_search_form(translated_specs)
      results = search_form.submit
      extract_links(to_nokogiri_page(results.body))
    end

    def fill_in_search_form(translated_specs)
      translated_specs.each do |field, value|
        search_form.add_field!(field.to_s, value)
      end
    end

    def to_nokogiri_page(html_page)
      Nokogiri::HTML(html_page)
    end

    def extract_links(nokogiri_page)
      nokogiri_links = nokogiri_page.xpath(link_xpath_string)
      nokogiri_links.map { |link| "#{base_page_url}#{link.value}" }
    end
  end
end
