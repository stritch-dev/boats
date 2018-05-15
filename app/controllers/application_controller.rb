require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do 
    if session then session.clear end
    haml :index
  end

  helpers do
    def current_user
      @current_user = nil
      if session[:user_id] 
        @current_user = User.find(session[:user_id])
      end
      @current_user
    end

    def logged_in?
      !!current_user
    end
  end

end
