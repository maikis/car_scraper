#
#
# This get's all the models for each make. This is a lot of traffic,
# so please use with care only if it's necessary in respect of Autogidas.
#
#

require 'net/http'
require 'json'
require_relative '../translation_config'

def convert_result(raw_models)
  models = []
  raw_models.map do |model|
    title = model['title']
    next if title.include?('Visi') || title.include?('kitas')
    models << title
  end
  models
end

makes = CarStalker::TRANSLATION_CONFIG[:make][:autogidas][:options]
result = {}

makes.map do |make|
  uri = URI('https://autogidas.lt/ajax/category/models?category_id='\
            "01&make=#{make}")
  response = Net::HTTP.get(uri)
  models = JSON.parse(response)['data']
  models = convert_result(models)
  result[:"#{make}"] = models
  sleep(2)
end

File.open('lib/car_stalker/data/autogidas_models.rb', 'w') do |file|
  file.write("module CarStalker\n  AUTOGIDAS_MODELS = #{result}\nend")
end
