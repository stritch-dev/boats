require './config/environment'
require 'pry-byebug'

class ReservationController < ApplicationController

  get '/reservations' do
    haml :'/reservations/reservation'
  end

  get '/reservations/new' do 
    haml :'/reservations/create_reservation'
  end

end
