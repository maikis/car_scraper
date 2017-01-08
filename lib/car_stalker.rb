require 'car_stalker/autoplius_scraper'

# Main interface for users to interact with the lib. It expects car specs with
# basic information, such as make, model, price, fuel type etc. to be given for
# the search. It looks like folowing:
#
# car_specs = {
#   make: 'BMW',
#   model: '330',
#   fuel_type: 'diesel',
#   price_to: 15000
# }
#
# More information about specs config can be found in documentation.
#
# TODO: Write documentation
#
module CarStalker
  def self.get_links(car_specs)
    CarStalker::AutopliusScraper.new.get_links(car_specs)
  end
end
