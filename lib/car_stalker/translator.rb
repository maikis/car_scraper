require 'car_stalker/translation_config'

module CarStalker
  # Converter from user friendly car_spec config to specific page config.
  class Translator
    class << self
      def translate(car_specs)
        translated_specs = {}
        car_specs.each do |spec, value|
          translated_specs = translate_spec(spec, value, translated_specs)
        end
        translated_specs
      end

      private

      def car_spec_data(spec)
        CarStalker::TRANSLATION_CONFIG.fetch(spec.to_sym)
      end

      def handle_value(value, mapping)
        if mapping.include?(:options)
          return translate_value(value, mapping[:options])
        end
        value
      end

      def translate_spec(spec, value, translated_specs)
        car_spec_data(spec).each do |site, mapping|
          value = handle_value(value, mapping)
          field = mapping.fetch(:field)
          if translated_specs.key?(site)
            translated_specs[site].merge!(:"#{field}" => value)
          else
            translated_specs[site] = { :"#{field}" => value }
          end
        end
        translated_specs
      end

      def translate_value(value, options)
        options.fetch(value.to_sym)
        # TODO: Raise error if option not found.
      end
    end
  end
end
