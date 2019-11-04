class UsersController < ApplicationController


  # GET: /users/new
  get "/signup" do 
    if logged_in?
      redirect to "/cocktail_recipes"
   else
    erb :"/users/new.html"
  end 
  end 

  # POST: /users
  post "/signup" do 
    if logged_in?
      redirect '/cocktail_recipes'
   elsif params[:username] == "" 
      flash[:message] = "Username cannot be blank. Please try again."
      redirect to '/signup'
   else
      @user = User.create(params)
      @user.save
      session[:user_id] = @user.id
      flash[:message] = "Welcome #{current_user.username}!"
      redirect '/cocktail_recipes'
  end
end 

g et "/login" do 
  if logged_in?
    redirect to "/fetishes"
  else
  erb :login 
  end 
  # GET: /users/5

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/cocktail_recipes'
    else
      flash[:message] = "Your username or password is incorrect. Please try again."
       redirect to '/signup'
    end
end

get '/logout' do
  if logged_in?
    session.destroy
    redirect to '/login'
  else
    redirect '/cocktail_recipes'
  end
end


  get "/users/:id" do 
    erb :"/users/show.html"
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    erb :"/users/edit.html"
  end

  # PATCH: /users/5
  patch "/users/:id" do
    redirect "/users/:id"
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    redirect "/users"
  end
end
