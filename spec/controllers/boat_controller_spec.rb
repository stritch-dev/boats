require 'spec_helper'
require 'pry-byebug'

describe BoatController do
  before do
    @good_params = {
      :name => "bob",
      :email => "bob@bob.test.com",
      :password => "bobpass"
    }

    @fred_params = {
      :name => "fred",
      :email => "fred@fred.test.com",
      :password => "fredpass"
    }

    @fred = User.create(@fred_params)

    @raven = Boat.create({name: 'Raven', size_description: 'four'})
    @heart = Boat.create({name: 'Heart', size_description: 'eight'})
  end

  describe "Delete page: " do
    it 'allows a logged in user to delete a boat' do
      login @fred
      visit "/boats/#{@raven.id}"

      click_button 'submit'

      expect(Boat.all.include? @raven).to eq(false)
      expect(page.current_path).to include('/boats')
    end
  end
end
