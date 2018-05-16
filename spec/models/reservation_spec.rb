require 'spec_helper'
require 'pry-byebug'

describe 'Reservation' do 

  before do 
    @user = User.create(:name => "Ben", :email => "ben@notreal.no.no", :password => "test")
    @boat = Boat.create(:name => 'Marigold', :size_description => 'four')
    @sample_reservation = Reservation.create(:user_id => @user.id,
                                      :boat_id => @boat.id,
                                      :start_time => '01/01/2001 5pm',
                                      :end_time => '01/01/2001 8pm',
                                      :recurring_instances => 0
                                     )
  end

  it 'can create a reservation and set values correctly'  do
    reservation = Reservation.create(:user_id => @user.id,
                                      :boat_id => @boat.id,
                                      :start_time => '01/01/2001 5pm',
                                      :end_time => '01/01/2001 8pm',
                                      :recurring_instances => 0
                                     )

    expect(reservation.user_id).to eq(@user.id)
    expect(reservation.boat_id).to eq(@boat.id)
    expect(reservation.start_time).to eq('01/01/2001 5pm')
    expect(reservation.end_time).to eq('01/01/2001 8pm')
  end
  
  it 'does not accept end date before start date' do
    before_attempt = Reservation.all.count

    reservation = Reservation.create(:user_id => @user.id,
                                      :boat_id => @boat.id,
                                      :start_time => '01/01/2001 5pm',
                                      :end_time => '01/01/2001 3pm',
                                      :recurring_instances => 0
                                     )

    expect(Reservation.all.count).to eq(before_attempt)
  end
  
  it 'correctly accepts end date that is after start date' do
    before_attempt = Reservation.all.count

    reservation = Reservation.create(:user_id => @user.id,
                                      :boat_id => @boat.id,
                                      :start_time => '01/01/2001 1pm',
                                      :end_time => '01/01/2001 3pm',
                                      :recurring_instances => 0
                                     )

    expect(Reservation.all.count).to eq(before_attempt + 1)
  end

  it 'prevents new reservation from starting within an existing reservation' do 
    before_conflict = Reservation.all.count

    start_time = @sample_reservation.end_time - 120 # 2 minutes
    conflicting_reservation = Reservation.create(:user_id => @user.id,
                                      :boat_id => @boat.id,
                                      :start_time => start_time,
                                      :end_time => '01/01/2001 8pm',
                                      :recurring_instances => 0
                                     )

    expect(Reservation.all.count).to eq(before_conflict)
  end


  it 'prevents new reservation from ending within an existing reservation' do 
    before_conflict = Reservation.all.count

    end_time = @sample_reservation.end_time - 120 # 2 minutes
    conflicting_reservation = Reservation.create(:user_id => @user.id,
                                      :boat_id => @boat.id,
                                      :start_time => '01/01/2001 8pm',
                                      :end_time => end_time,
                                      :recurring_instances => 0
                                     )

    expect(Reservation.all.count).to eq(before_conflict)
  end

  it 'prevents new reservation from engulfing an existing reservation' do
    before_conflict = Reservation.all.count

    start_time = @sample_reservation.start_time - 120 # 2 minutes
    end_time = @sample_reservation.end_time + 120 # 2 minutes
    conflicting_reservation = Reservation.create(:user_id => @user.id,
                                      :boat_id => @boat.id,
                                      :start_time => start_time,
                                      :end_time => end_time,
                                      :recurring_instances => 0
                                     )

    expect(Reservation.all.count).to eq(before_conflict)
  end

  it 'allows reservations of acceptable duration' do
    expect(@sample_reservation.acceptable_duration?).to eq(true)
  end

  it 'prohibits reservations of duration greater than max' do
    before_conflict = Reservation.all.count

    illegal_duratation_reservation = Reservation.create(
                                        :user_id => @user.id,
                                        :boat_id => @boat.id,
                                        :start_time => '01/01/2022 1pm',
                                        :end_time => '01/02/2022 2pm',
                                        :recurring_instances => 0
                                       )

    expect(Reservation.all.count).to eq(before_conflict)
  end

  xit 'prevents reservation of non-existant boat' do
    before_conflict = Reservation.all.count

    illegal_duratation_reservation = Reservation.new(
                                        :user_id => @user.id,
                                        :boat_id => -1,
                                        :start_time => '03/03/2022 1pm',
                                        :end_time => '03/03/2022 2pm',
                                        :recurring_instances => 0
                                       )

    expect{illegal_duratation_reservation.save!}.to raise_error(ActiveRecord::RecordNotFound)
  end

  xit 'prevents reservation by non-existant user' do
    before_conflict = Reservation.all.count

    illegal_duratation_reservation = Reservation.create(
                                        :user_id => -1,
                                        :boat_id => @boat.id,
                                        :start_time => '01/01/2022 1pm',
                                        :end_time => '01/01/2022 2pm',
                                        :recurring_instances => 0
                                       )

    expect(Reservation.all.count).to eq(before_conflict)
  end



end
