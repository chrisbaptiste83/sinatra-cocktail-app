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
      @user = User.create(username: params[:username], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
      session[:user_id] = @user.id 
      flash[:message] = "Your account has been succesfully created!"
      erb :"/users/index.html"
      end
  end 

end 