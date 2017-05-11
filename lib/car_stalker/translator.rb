require 'car_stalker/translation_config'

module CarStalker
  # Converter from user friendly car_spec config to specific page config.
  class Translator
    class << self
      def translate(car_specs, website)
        validate_specs(car_specs, website)
        translated_specs = {}
        car_specs.each do |spec, value|
          translated_specs = translate_spec(spec,
                                            value,
                                            translated_specs,
                                            website)
        end
        translated_specs
      end

      private

      def car_spec_data(spec, website)
        CarStalker::TRANSLATION_CONFIG.fetch(spec.to_sym).fetch(website.to_sym)
      end

      def handle_value(spec, value, mapping, website)
        if spec == :make
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

      def translate_spec(spec, value, translated_specs, website)
        mapping = car_spec_data(spec, website)
        site_value = handle_value(spec, value, mapping, website)
        field = mapping.fetch(:field)
        if translated_specs.key?(website)
          translated_specs[website][:"#{field}"] = site_value
        else
          translated_specs[website] = { :"#{field}" => site_value }
        end
        translated_specs
      end

      def translate_value(value, options)
        options.fetch(value.to_sym)
        # TODO: Raise error if option not found.
      end

      def validate_specs(car_specs, website)
        details = {}
        message = 'Unsupported spec.'

        unless car_specs[:make].nil?
          options = car_spec_data(:make, website).fetch(:options, {})
          value   = car_specs[:make].to_sym
          unless options.include?(value)
            details = {
              make: "Make '#{value}' is not supported by '#{website}'."
            }
          end
        end

        return if details.empty?
        raise CarStalker::UnsupportedSpecError.new(message, details)
      end
    end
  end
end
