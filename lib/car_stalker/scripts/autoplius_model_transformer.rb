require 'nokogiri'
require 'json'

#
#
# This one is safe to use as it is not querying Autoplius. Autoplius site
# contains all the makes and models in its HTML / JavaScript, so it does not
# need to query the database each time. Though if you want to update make /
# model list, you need to extract them by hand from the page.
#
#

raw_makes = File.read('lib/car_stalker/data/raw_autoplius_makes.html')
raw_models = File.read('lib/car_stalker/data/raw_autoplius_models.json')

nokogiri_makes = Nokogiri::HTML(raw_makes)
models = JSON.parse(raw_models)

result = {}
nokogiri_makes.xpath('//option').map do |o|
  converted_models = models[o.values.first].map do |_, model|
    model unless model.include?('kita')
  end
  result[:"#{o.text}"] = converted_models.compact
end

File.open('lib/car_stalker/data/autoplius_models.rb', 'w') do |file|
  file.write("module CarStalker\n  AUTOPLIUS_MODELS = #{result}\nend")
end
