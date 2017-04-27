require 'net/http'
require 'json'
require_relative '../translation_config'

makes = CarStalker::TRANSLATION_CONFIG[:make][:autogidas][:options]

result = []

makes.map do |make|
	uri = URI("https://autogidas.lt/ajax/category/models?category_id=01&make=#{make}")
	response = Net::HTTP.get(uri)
	puts response
	models = JSON.parse(response)['data']
	result << { "#{make}": models }
	sleep(2)
end

File.open('lib/car_stalker/scripts/autogidas_models.rb', 'w') { |file| file.write(result) }
