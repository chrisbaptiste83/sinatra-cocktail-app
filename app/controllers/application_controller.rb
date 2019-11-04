require './config/environment'
require 'sinatra' 

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views' 
    enable :sessions
		set :session_secret, "password_security"


  get "/" do
    erb :welcome
  end 

  

  helpers do
   
        def logged_in?
        !!session[:user_id]
        end

        def current_user #possible change
          User.find_by(:id => session[:user_id]) 
        end
  
    end

  end

end 