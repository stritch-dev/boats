require 'spec_helper'

describe 'Boat' do 
  it 'can create a boat'  do
    @boat = Boat.create(:name => 'Marigold', :size_description => 'four')
    expect(@boat.name).to eq('Marigold')
    expect(@boat.size_description).to eq('four')
  end
end
