require 'car_stalker/autoplius_scraper'

# Main interface for users to interact with the lib. It expects car specs with
# basic information, such as make, model, price, fuel type etc. to be given for
# the search. It looks like folowing:
#
# car_specs = {
#   make_id_list: 'Audi',
#   make_id_sublist_portal: 'A3',
#   kilometrage_to: '20000',
#   make_date_from: 2016 }
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
