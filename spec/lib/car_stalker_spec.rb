require 'spec_helper'

describe CarStalker do
  # xit'ed because I still have to find a way to stub web pages for scraping
  # with poltergeist.
  xit 'returns a list of links' do
    results = CarStalker.get_links({ make: 'Volkswagen',
                                     model: 'Golf',
                                     kilometrage_to: '70000',
                                     year_from: 2012,
                                     price_to: '10000',
                                     damaged: :no })
    require 'byebug'; byebug
    expect(results).to be_a(Array)
    expect(results.size).to eq(20)
  end
end
