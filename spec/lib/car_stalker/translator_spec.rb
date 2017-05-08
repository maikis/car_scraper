require 'spec_helper'

describe CarStalker::Translator do
  describe 'target specific translations' do
    specs = { make: 'Volkswagen', model: 'Golf' }
    
    it 'translates specs for autoplius' do
      expect(described_class.translate(specs)).to include(:autoplius)
    end

    it 'translates specs for autogidas' do
      expect(described_class.translate(specs)).to include(:autogidas)
    end
  end

  describe 'autoplius' do
    it 'translates specs using specified options' do
      specs = { damaged: :no,
                fuel_type: :petrol,
                gearbox: :automatic,
                body_type: :hatchback }
      expect(described_class.translate(specs).fetch(:autoplius))
        .to eq(has_damaged_id: 'No damages',
               fuel_id: 'Petrol',
               gearbox_id: 'Automatic',
               body_type_id: 'Hatchback')
    end
  end

  describe 'autogidas' do
    it 'translates specs using specified options' do
      specs = { damaged: :no,
                fuel_type: :petrol,
                gearbox: :automatic,
                body_type: :hatchback }
      expect(described_class.translate(specs).fetch(:autogidas))
        .to eq(f_46: 'Be defektų',
               f_2: 'Benzinas',
               f_10: 'Automatinė',
               f_3: 'Hečbekas')
    end
  end
end
