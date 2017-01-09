require 'spec_helper'

describe CarStalker do
  # xit'ed because I still have to find a way to stub web pages for scraping
  # with poltergeist.
  xit 'returns a list of links' do
    results = CarStalker.get_links({ make_id_list: 'Volkswagen',
                                     make_id_sublist_portal: 'Golf',
                                     kilometrage_to: '70000',
                                     make_date_from: 2012,
                                     sell_price_to: '10000',
                                     has_damaged_id: 'Be defektų' })
    expect(results).to be_a(Array)
    expect(results.size).to eq(20)
  end
end
