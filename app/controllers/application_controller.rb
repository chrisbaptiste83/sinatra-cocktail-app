require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views' 
    set :sessions, true
		set :session_secret, ENV['SESSION_SECRET']
  
  get "/" do
    erb :welcome
  end 

  

  helpers do
   
        def logged_in?
        !!session[:user_id]
        end

        def current_user 
          User.find_by(:id => session[:user_id]) 
        end
  
    end

  end 

end 