require 'spec_helper'
require 'pry-byebug'

describe ReservationController do

  before do
    @bob_params = {
      :name => "bob",
      :email => "bob@bob.test.com",
      :password => "bobpass"
    }

    @bob_params = {
      :name => "bob",
      :email => "bob@bob.test.com",
      :password => "bobpass"
    }
    @fred_params = {
      :name => "fred",
      :email => "fred@fred.test.com",
      :password => "fredpass"
    }

    @bob = User.create(@bob_params)
    @fred = User.create(@fred_params)
    login @fred

    @raven = Boat.create({name: 'Raven', size_description: 'four'})
    @heart = Boat.create({name: 'Heart', size_description: 'eight'})

  end

  describe "Reservation Page" do
    it 'loads' do
      visit '/reservations'
      expect(page.current_path).to eq('/reservations')
    end
  end

  describe "New Reservation Page" do
    start_time = '/7/2018 7am'
    end_time = '/7/2018 8am'
    recurring_instances = 3

    it 'allows a user to reserve a boat' do
      visit '/reservations/new'
      find("option[value='#{@raven.id}']").click
      fill_in(:start_time, :with => start_time)
      fill_in(:end_time, :with => end_time)
      fill_in(:recurring_instances, :with => recurring_instances)
      click_button 'submit'

      new_reservation = Reservation.find_by(
        :user_id => @fred.id,
        :boat_id => @raven.id,
        :start_time => start_time,
        :end_time => end_time,
        :recurring_instances => recurring_instances)

      expect(new_reservation).to be_instance_of(Reservation)
      expect(new_reservation.boat.name).to eq('Raven')
      expect(new_reservation.start_time).to eq(start_time)
      expect(new_reservation.end_time).to eq(end_time)
      expect(new_reservation.recurring_instances).to eq(recurring_instances)
    end
  end

  describe "Delete Action" do
    start_time = '/7/2018 7am'
    end_time = '/7/2018 8am'
    recurring_instances = 3

    before do
      @reservation_one = Reservation.create({ :user_id => @bob.id,
                           :boat_id => @heart.id,
                           :start_time => "May 4 2010 4pm",
                           :end_time => "May 4 2010 8pm",
                           :recurring_instances => 1
      })

      @reservation_two = Reservation.create({ :user_id => @fred.id,
                           :boat_id => @raven.id,
                           :start_time => start_time,
                           :end_time => end_time,
                           :recurring_instances => recurring_instances
      })
    end

    it 'allows users to delete their own reservations' do
      visit '/reservations'

      click_button( "delete_#{@reservation_two.id}")
      raven = Reservation.any? { |r| r.id == @reservation_two.id }

      expect(raven).to eq(false)
    end

    it "prevents users from deleting other users' reservations" do
      visit '/reservations'
       expect(page).to have_no_content("delete_#{@reservations_two}")
    end
  end

end
