require 'car_stalker/autoplius_scraper'
require 'car_stalker/autogidas_scraper'
require 'car_stalker/translator'

# Main interface for users to interact with the lib. It expects car specs with
# basic information, such as make, model, price, fuel type etc. to be given for
# the search. It looks like following:
#
# car_specs = {
#   make: 'Audi',
#   model: 'A3',
#   kilometrage_to: '20000',
#   year_from: 2016 }
#
# More information about specs config can be found in documentation.
#
# TODO: Write documentation
#
module CarStalker
  def self.get_links(car_specs)
    CarStalker::AutopliusScraper.new.get_links(car_specs)
    CarStalker::AutogidasScraper.new.get_links(car_specs)
  end
end
