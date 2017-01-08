require 'spec_helper'

describe CarStalker do

  it 'returns a list of links' do
    results = CarStalker.get_links({ make_id_list: 'BMW' })
    expect(results).to be_a(Array)
    expect(results.size).to eq(20)
  end
end
