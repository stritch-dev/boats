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
    if (!params[:boat_id].empty? &&
    !params[:start_time].empty? &&
    !params[:end_time].empty? &&
    !params[:recurring_instances].empty? 
    )
      r = Reservation.create({
        :user_id => session[:user_id],
        :boat_id => params[:boat_id],
        :start_time => params[:start_time],
        :end_time => params[:end_time],
        :recurring_instances => params[:recurring_instances]
      })
      if !r.persisted?
        flash[:message] = "Your reservation could not be made. Please try again using a valid date format."
        redirect '/reservations/new'
      end
    end
      redirect '/reservations'
  else
    flash[:message] = "You must fill out all fields. Please try again."
    redirect '/reservations/new'
  end

  delete '/reservations/:id' do
    @reservation = Reservation.find(params[:id])
    @reservation.destroy 
    redirect :'/reservations'
  end
end
