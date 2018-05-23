require 'spec_helper'
require 'pry-byebug'

describe UserController do

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

  describe "Reservation Page" do
    it 'loads' do
      get '/reservations'
      expect(last_response.status).to eq(200)
  end

