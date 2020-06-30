class SessionsController < ApplicationController

  get "/login" do 
    if logged_in?
      redirect to "/user"
    else
    erb :login 
    end 
  end 
    
  
  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/user' 
    elsif params[:username].empty? || params[:password].empty? 
        flash[:message] = "Username or password cannot be blank. please try again."
        erb :login 
    else 
      flash[:message] = "Incorrect username or password. Please try again."
      erb :login
    end
  end
  
  delete '/logout' do 
    session.destroy
    redirect to '/'
  end 
  
end
