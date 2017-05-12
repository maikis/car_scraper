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

  describe 'autoplius' do
    it 'translates specs using specified options' do
      specs = { damaged: :no,
                fuel_type: :petrol,
                gearbox: :automatic,
                body_type: :hatchback }
      expect(described_class.translate(specs, :autoplius).fetch(:autoplius))
        .to eq(has_damaged_id: 'No damages',
               fuel_id: 'Petrol',
               gearbox_id: 'Automatic',
               body_type_id: 'Hatchback')
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
  end

  describe 'autogidas' do
    it 'translates specs using specified options' do
      specs = { damaged: :no,
                fuel_type: :petrol,
                gearbox: :automatic,
                body_type: :hatchback }
      expect(described_class.translate(specs, :autogidas).fetch(:autogidas))
        .to eq(f_46: 'Be defektų',
               f_2: 'Benzinas',
               f_10: 'Automatinė',
               f_3: 'Hečbekas')
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
  end
end
