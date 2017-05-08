require 'car_stalker/translation_config'

module CarStalker
  # Converter from user friendly car_spec config to specific page config.
  class Translator
    class << self
      attr_reader :car_specs

      def translate(car_specs)
        @car_specs = car_specs
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

      def handle_value(spec, value, mapping)
        if spec == :make
          # TODO: Validate make
          return value
        elsif spec == :model
          # TODO: Validate model
          return value
        end

        if mapping.fetch(:options).is_a?(Hash)
          return translate_value(value, mapping.fetch(:options))
        end
        value
      end

      def translate_spec(spec, value, translated_specs)
        car_spec_data(spec).each do |web_site, mapping|
          site_value = handle_value(spec, value, mapping)
          field = mapping.fetch(:field)
          if translated_specs.key?(web_site)
            translated_specs[web_site].merge!(:"#{field}" => site_value)
          else
            translated_specs[web_site] = { :"#{field}" => site_value }
          end
        end
        translated_specs
      end

      def translate_value(value, options)
        options.fetch(value.to_sym)
        # TODO: Raise error if option not found.
      end

      def validate_value(value, options)
        options.include?(value)
      end
    end
  end
end
