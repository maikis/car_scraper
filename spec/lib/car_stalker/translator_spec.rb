require 'spec_helper'

describe CarStalker::Translator do
  it 'translates specs without options' do
    specs = { make: 'Volkswagen',
              model: 'Golf',
              kilometrage_to: '70000',
              year_from: 2012,
              price_to: '10000' }
    expect(CarStalker::Translator.translate(specs)[:autoplius])
      .to eq({ make_id_list: 'Volkswagen',
               make_id_sublist_portal: 'Golf',
               kilometrage_to: '70000',
               make_date_from: 2012,
               sell_price_to: '10000' })
  end

  it 'translates options' do
    specs = { damaged: :no,
              fuel_type: :petrol,
              gearbox: :automatic,
              body_type: :hatchback }
    expect(CarStalker::Translator.translate(specs)[:autoplius])
      .to eq(has_damaged_id: 'No damages',
             fuel_id: 'Petrol',
             gearbox_id: 'Automatic',
             body_type_id: 'Hatchback')
  end
end
