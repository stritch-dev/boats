require './config/environment'
require 'pry-byebug'

class UserController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect '/boats'
    end
    haml :'/users/create_user'
  end

  post '/signup' do
    if params[:name] == "" || params[:email] == "" || params[:password] == "" 
      # TODO add error message
      redirect '/signup'
    end
    session[:user_id] = User.create({:name => params[:name], :email => params[:email], :password => [:password]}).id
    redirect '/boats'
  end

  get '/login' do
    if logged_in?
      redirect '/boats' # TODO what should user's home page be?
    else
      haml :'/users/login'
    end
  end

  post '/login' do
    @user=User.find_by(:name => params[:name])
    if @user
      session[:user_id] = @user.id
      redirect '/boats'
    else 
      redirect '/signup'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end
end
