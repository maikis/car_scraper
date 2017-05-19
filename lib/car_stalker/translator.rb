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

        if car_specs[:make].nil?
          # Model is present, but make is missing.
          unless car_specs[:model].nil?
            details[:model] = "Model can't be passed alone: it is dependent on"\
                              ' make.'
          end
        else
          options = car_spec_data(:make, website).fetch(:options, {})
          value   = car_specs[:make].to_sym
          # Make is not supported.
          if options.include?(value)
            options = car_spec_data(:model, website).fetch(:options, {})
            value   = car_specs[:model].to_s
            # Make is present and supported, but model is not supported.
            unless options[car_specs[:make].to_sym].include?(value)
              details[:model] = "Model '#{value}' is not supported by"\
                                " '#{website}'."
            end
          else
            details[:make] = "Make '#{value}' is not supported by '#{website}'."
          end
        end

        car_specs.each do |spec, option|
          next if spec == :make
          next if spec == :model

          all_options = car_spec_data(spec, website).fetch(:options, {})
          option      = car_specs[spec]

          case all_options
          when Range
            next if all_options.include?(option)
            details[spec.to_sym] = "Must be in range #{all_options}"
          when Hash
            next if all_options.keys.include?(option)
            details[spec.to_sym] = "Value '#{option}' is not supported. Please"\
                                   ' consult the documentation for supported'\
                                   ' values.'
          end
        end

        return if details.empty?
        raise CarStalker::UnsupportedSpecError.new(message, details)
      end
    end
  end
end
