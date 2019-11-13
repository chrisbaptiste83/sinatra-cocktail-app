class UsersController < ApplicationController 

  get "/user" do 
    if logged_in?
      @user = current_user
      erb :"users/index.html"
     else
      redirect to '/login'
    end
  end


  get '/signup' do 
    if logged_in?
      redirect to "/user"
   else
    erb :"/users/new.html"
    end 
  end 


  post "/signup" do 
      if params[:username].empty? || params[:email].empty? || params[:password].empty? 
      flash[:message] = "You must complete all fields in order to create a username. Please try again."
      redirect to '/signup'
      else
      @user = User.create(username: params[:username], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
      session[:user_id] = @user.id 
      flash[:message] = "Your account has been succesfully created!"
      erb :"/users/index.html"
      end
  end 

end 