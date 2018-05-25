require './config/environment'
require 'pry-byebug'

class ReservationController < ApplicationController

  get '/reservations' do
    haml :'/reservations/reservations'
  end

  get '/reservations/new' do 
    haml :'/reservations/new'
  end

  post '/reservations' do
    STDERR.puts "-------- in reservation_controller.rb ------------------"
    STDERR.puts params
    STDERR.puts "user_id #{session[:user_id]}"
    STDERR.puts "-------- -------------- ------------------"
    Reservation.create({
      :user_id => session[:user_id],
      :boat_id => params[:boat_id],
      :start_time => params[:start_time],
      :end_time => params[:end_time],
      :recurring_instances => params[:recurring_instances]
      }
    )
    redirect '/reservations'
  end

  delete '/reservations/:id' do
    @reservation = Reservation.find(params[:id])
    @reservation.destroy 
    redirect :'/reservations'
  end

end
