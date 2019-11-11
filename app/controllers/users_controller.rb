class UsersController < ApplicationController 

  get "/user" do #read; see all items
    if logged_in?
      @user = current_user 
      @cocktail_recipes = CocktailRecipe.all
      erb :"users/index.html"
     else
      redirect to '/login'
    end
  end


  get '/signup' do 
    if logged_in?
      redirect to "/cocktail_recipes"
   else
    erb :"/users/new.html"
    end 
  end 


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
      flash[:message] = "Your account has been succesfully created!"
      erb :"/users/index.html"
  end
end 

get "/login" do 
  if logged_in?
    redirect to "/user"
  else
  erb :login 
  end 
end 
  # GET: /users/5

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/user'
    else
      flash[:message] = "Your username or password is incorrect. Please try again."
       redirect to '/login'
    end
end

get '/logout' do
  if logged_in?
    session.destroy
    redirect to '/'
  else
    redirect '/login'
  end
end

end 