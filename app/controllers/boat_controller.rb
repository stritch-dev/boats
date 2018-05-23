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
  
  get '/boats/:id/edit' do
    @boat = Boat.find(params[:id])
    haml :'/boats/edit'
  end

  patch '/boats/:id' do
    @boat = Boat.find(params[:id])
    if params[:name] != "" && params[:size_description] != ""
      @boat.update(name: params['name'], size_description: params['size_description'])
      redirect "/boats/#{params[:id]}"
    else
    redirect "/boats/#{params['id']}/edit"
    end
  end

  delete '/boats/:id' do
    @boat = Boat.find(params[:id])
    @boat.destroy 
    redirect :'/boats'
  end

end
