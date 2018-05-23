require './config/environment'
require 'pry-byebug'

class BoatController < ApplicationController

  before do
    if !logged_in? then redirect :'/users/login' end
  end

  get '/boats' do
    if !logged_in? then redirect :'/login' end
    haml :'/boats/boats'
  end

  post '/boats' do
    Boat.create({:name => params[:name], :size_description => params[:size_description]})
    redirect '/boats'
  end

  get '/boats/new' do
    haml :'boats/new'
  end

  get '/boats/:id' do
    @boat = Boat.find(params[:id])
    haml :'boats/show'
  end

end
