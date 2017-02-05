require 'car_stalker/translation_config'

module CarStalker
  # Converter from user friendly car_spec config to specific page config.
  class Translator
    class << self
      def translate(car_specs)
        translated_specs = {}
        car_specs.each do |spec, value|
          transl_data = CarStalker::TRANSLATION_CONFIG.fetch(spec.to_sym)
          transl_data.each do |site, mapping|
            field = mapping.fetch(:field)
            if translated_specs.key?(site)
              translated_specs[site].merge!(:"#{field}" => value)
            else
              translated_specs[site] = { :"#{field}" => value }
            end
          end
        end
        translated_specs
      end
    end
  end
end
