require 'spec_helper'

describe CarStalker::Translator do
  describe 'target specific translations' do
    specs = { make: 'Volkswagen', model: 'Golf' }

    it 'translates specs for autoplius' do
      expect(described_class.translate(specs, :autoplius))
        .to include(:autoplius)
    end

    it 'translates specs for autogidas' do
      expect(described_class.translate(specs, :autogidas))
        .to include(:autogidas)
    end
  end

  common_specs = { engine_capacity_from: 800,
                   engine_capacity_to: 5600,
                   power_from: '44 kW (60 AG)',
                   power_to: '334 kW (454 AG)',
                   kilometrage_from: 0,
                   kilometrage_to: 250_000,
                   year_from: 1985,
                   year_to: 2017,
                   price_from: 150,
                   price_to: 60_000,
                   driven_wheels: :rwd,
                   damaged: :no,
                   fuel_type: :petrol,
                   gearbox: :automatic,
                   body_type: :hatchback,
                   steering_wheel_side: :lhd }

  describe 'autoplius' do
    it 'translates specs using specified options' do
      expect(described_class
               .translate(common_specs, :autoplius)
               .fetch(:autoplius))
        .to eq(engine_capacity_from: 800,
               engine_capacity_to: 5600,
               power_from: '44 kW (60 AG)',
               power_to: '334 kW (454 AG)',
               kilometrage_from: 0,
               kilometrage_to: 250_000,
               make_date_from: 1985,
               make_date_to: 2017,
               sell_price_from: 150,
               sell_price_to: 60_000,
               wheel_drive_id: 'Rear wheel drive (RWD)',
               has_damaged_id: 'No damages',
               fuel_id: 'Petrol',
               gearbox_id: 'Automatic',
               body_type_id: 'Hatchback',
               steering_wheel_id: 'Left hand drive (LHD)')
    end

    it 'raises CarStalker::UnsupportedSpecError if make is not supported' do
      specs = { make: 'Unknown_make' }
      expect { described_class.translate(specs, :autoplius) }
        .to raise_error do |error|
          expect(error).to be_a(CarStalker::UnsupportedSpecError)
          expect(error.message).to eq('Unsupported spec.')
          expect(error.details)
            .to eq(
              make: "Make '#{specs[:make]}' is not supported by 'autoplius'."
            )
        end
    end

    it 'raises CarStalker::UnsupportedSpecError if make is missing when model'\
       ' is present' do
      specs = { model: 'Golf' }
      expect { described_class.translate(specs, :autoplius) }
        .to raise_error do |error|
          expect(error).to be_a(CarStalker::UnsupportedSpecError)
          expect(error.message).to eq('Unsupported spec.')
          expect(error.details)
            .to eq(
              model: "Model can't be passed alone: it is dependent on make."
            )
        end
    end

    it 'raises CarStalker::UnsupportedSpecError if model is not supported' do
      specs = { make: 'Volkswagen', model: 'Unsupported' }
      expect { described_class.translate(specs, :autoplius) }
        .to raise_error do |error|
          expect(error).to be_a(CarStalker::UnsupportedSpecError)
          expect(error.message).to eq('Unsupported spec.')
          expect(error.details)
            .to eq(
              model: "Model '#{specs[:model]}' is not supported by 'autoplius'."
            )
        end
    end

    it 'raises CarStalker::UnsupportedSpecError if validation of Range options'\
       ' fail' do
      specs = { engine_capacity_from: 700, # Less than 800 not supported.
                engine_capacity_to:   700, # Less than 800 not supported.
                kilometrage_from: 250_001, # More than 250_000 not supported.
                kilometrage_to:   250_001, # More than 250_000 not supported.
                year_from: 1050, # Less than 1985 not supported.
                year_to:   1050, # Less than 1985 not supported.
                price_from: 50,  # Less than 150 not supported.
                price_to:   50 } # Less than 150 not supported.
      expect { described_class.translate(specs, :autoplius) }
        .to raise_error do |error|
          expect(error).to be_a(CarStalker::UnsupportedSpecError)
          expect(error.message).to eq('Unsupported spec.')
          expect(error.details)
            .to eq(
              engine_capacity_from: 'Must be in range 800..5600',
              engine_capacity_to: 'Must be in range 800..5600',
              kilometrage_from: 'Must be in range 0..250000',
              kilometrage_to:   'Must be in range 0..250000',
              year_from: 'Must be in range 1985..2017',
              year_to:   'Must be in range 1985..2017',
              price_from: 'Must be in range 150..60000',
              price_to:   'Must be in range 150..60000'
            )
        end
    end

    it 'raises CarStalker::UnsupportedSpecError if validation of Hash options'\
       ' fail' do
      # All the following specs are unsupported.
      specs = { damaged: 'slightly',
                fuel_type: 'atomic_energy',
                gearbox: 'unsupported',
                body_type: 'unidentified',
                driven_wheels: 'unknown',
                steering_wheel_side: 'variable' }
      expect { described_class.translate(specs, :autoplius) }
        .to raise_error do |error|
          expect(error).to be_a(CarStalker::UnsupportedSpecError)
          expect(error.message).to eq('Unsupported spec.')
          expect(error.details)
            .to eq(
              damaged: "Value 'slightly' is not supported. Please consult the"\
                       ' documentation for supported values.',
              fuel_type: "Value 'atomic_energy' is not supported. Please"\
                         ' consult the documentation for supported values.',
              gearbox: "Value 'unsupported' is not supported. Please consult"\
                       ' the documentation for supported values.',
              body_type: "Value 'unidentified' is not supported. Please"\
                         ' consult the documentation for supported values.',
              driven_wheels: "Value 'unknown' is not supported. Please consult"\
                             ' the documentation for supported values.',
              steering_wheel_side: "Value 'variable' is not supported. Please"\
                                   ' consult the documentation for supported'\
                                   ' values.'
            )
        end
    end

    it 'raises CarStalker::UnsupportedSpecError if validation of Array options'\
       ' fail' do
      # All the following specs are unsupported.
      specs = { power_from: 'not_enough_power',
                power_to: 'super_power' }
      expect { described_class.translate(specs, :autoplius) }
        .to raise_error do |error|
          expect(error).to be_a(CarStalker::UnsupportedSpecError)
          expect(error.message).to eq('Unsupported spec.')
          expect(error.details)
            .to eq(
              power_from: "Value 'not_enough_power' is not supported. Please"\
                          ' consult the documentation for supported values.',
              power_to: "Value 'super_power' is not supported. Please consult"\
                        ' the documentation for supported values.'
            )
        end
    end
  end

  describe 'autogidas' do
    it 'translates specs using specified options' do
      expect(described_class
               .translate(common_specs, :autogidas)
               .fetch(:autogidas))
        .to eq(f_61: 800,
               f_62: 5600,
               f_63: '44 kW (60 AG)',
               f_64: '334 kW (454 AG)',
               f_65: 0,
               f_66: 250_000,
               f_41: 1985,
               f_42: 2017,
               f_215: 150,
               f_216: 60_000,
               f_12: 'Galiniai varantys ratai',
               f_46: 'Be defektų',
               f_2: 'Benzinas',
               f_10: 'Automatinė',
               f_3: 'Hečbekas',
               f_265: 'Kairėje')
    end

    it 'raises CarStalker::UnsupportedSpecError if make is not supported' do
      # Abarth is known to autoplius, so it does not fail on autoplius
      # translation, which goes before autogidas.
      specs = { make: 'Abarth' }
      expect { described_class.translate(specs, :autogidas) }
        .to raise_error do |error|
          expect(error).to be_a(CarStalker::UnsupportedSpecError)
          expect(error.message).to eq('Unsupported spec.')
          expect(error.details)
            .to eq(
              make: "Make '#{specs[:make]}' is not supported by 'autogidas'."
            )
        end
    end

    it 'raises CarStalker::UnsupportedSpecError if make is missing when model'\
       ' is present' do
      specs = { model: 'Golf' }
      expect { described_class.translate(specs, :autogidas) }
        .to raise_error do |error|
          expect(error).to be_a(CarStalker::UnsupportedSpecError)
          expect(error.message).to eq('Unsupported spec.')
          expect(error.details)
            .to eq(
              model: "Model can't be passed alone: it is dependent on make."
            )
        end
    end

    it 'raises CarStalker::UnsupportedSpecError if model is not supported' do
      specs = { make: 'Volkswagen', model: 'Unsupported' }
      expect { described_class.translate(specs, :autogidas) }
        .to raise_error do |error|
          expect(error).to be_a(CarStalker::UnsupportedSpecError)
          expect(error.message).to eq('Unsupported spec.')
          expect(error.details)
            .to eq(
              model: "Model '#{specs[:model]}' is not supported by 'autogidas'."
            )
        end
    end

    it 'raises CarStalker::UnsupportedSpecError if validation of Range options'\
       ' fail' do
      specs = { engine_capacity_from: 700, # Less than 0.8 not supported.
                engine_capacity_to:   700, # Less than 0.8 not supported.
                kilometrage_from: 250_001, # More than 250_000 not supported.
                kilometrage_to:   250_001, # More than 250_000 not supported.
                year_from: 1050, # Less than 1985 not supported.
                year_to:   1050, # Less than 1985 not supported.
                price_from: 50,  # Less than 150 not supported.
                price_to:   50 } # Less than 150 not supported.
      expect { described_class.translate(specs, :autogidas) }
        .to raise_error do |error|
          expect(error).to be_a(CarStalker::UnsupportedSpecError)
          expect(error.message).to eq('Unsupported spec.')
          expect(error.details)
            .to eq(
              engine_capacity_from: 'Must be in range 0.8..6.0',
              engine_capacity_to: 'Must be in range 0.8..6.0',
              kilometrage_from: 'Must be in range 0..250000',
              kilometrage_to:   'Must be in range 0..250000',
              year_from: 'Must be in range 1985..2017',
              year_to:   'Must be in range 1985..2017',
              price_from: 'Must be in range 150..60000',
              price_to:   'Must be in range 150..60000'
            )
        end
    end

    it 'raises CarStalker::UnsupportedSpecError if validation of Hash options'\
       ' fail' do
      # All the following specs are unsupported.
      specs = { damaged: 'slightly',
                fuel_type: 'atomic_energy',
                gearbox: 'unsupported',
                body_type: 'unidentified',
                driven_wheels: 'unknown',
                steering_wheel_side: 'variable' }
      expect { described_class.translate(specs, :autogidas) }
        .to raise_error do |error|
          expect(error).to be_a(CarStalker::UnsupportedSpecError)
          expect(error.message).to eq('Unsupported spec.')
          expect(error.details)
            .to eq(
              damaged: "Value 'slightly' is not supported. Please consult the"\
                       ' documentation for supported values.',
              fuel_type: "Value 'atomic_energy' is not supported. Please"\
                         ' consult the documentation for supported values.',
              gearbox: "Value 'unsupported' is not supported. Please consult"\
                       ' the documentation for supported values.',
              body_type: "Value 'unidentified' is not supported. Please"\
                         ' consult the documentation for supported values.',
              driven_wheels: "Value 'unknown' is not supported. Please consult"\
                             ' the documentation for supported values.',
              steering_wheel_side: "Value 'variable' is not supported. Please"\
                                   ' consult the documentation for supported'\
                                   ' values.'
            )
        end
    end

    it 'raises CarStalker::UnsupportedSpecError if validation of Array options'\
       ' fail' do
      # All the following specs are unsupported.
      specs = { power_from: 'not_enough_power',
                power_to: 'super_power' }
      expect { described_class.translate(specs, :autogidas) }
        .to raise_error do |error|
          expect(error).to be_a(CarStalker::UnsupportedSpecError)
          expect(error.message).to eq('Unsupported spec.')
          expect(error.details)
            .to eq(
              power_from: "Value 'not_enough_power' is not supported. Please"\
                          ' consult the documentation for supported values.',
              power_to: "Value 'super_power' is not supported. Please consult"\
                        ' the documentation for supported values.'
            )
        end
    end
  end
end
