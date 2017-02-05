require 'spec_helper'

describe CarStalker::Translator do
  it 'transaltes for autoplius' do
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
end
