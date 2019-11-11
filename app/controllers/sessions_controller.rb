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
      if user 
        if user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect to '/user' 
        else 
          flash[:message] = "Your password is incorrect. Please try again."
          erb :login 
        end 
      else
        flash[:message] = "This user does not exist. Sign up to create a user."
        redirect to '/signup'
      end
  end
  
  delete '/logout' do
    if logged_in?
      session.destroy
      redirect to '/'
    else
      redirect '/login'
    end
  end 

end
