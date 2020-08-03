class UsersController < ApplicationController 

  get '/users/:slug' do 
    @cocktail_recipe = CocktailRecipe.all.last 
    @random_cocktail_recipe = CocktailRecipe.all.order('RANDOM()').first
    if logged_in?
      @user = User.find_by_slug(params[:slug]) 
      if current_user != @user 
        erb :"users/show.html"  
      else  
        erb :"users/index.html"   
      end 
    else 
      redirect to "/login" 
    end         
  end


  get '/signup' do 
    if logged_in?
      redirect to "/users/#{current_user.username}"
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
      redirect to "/users/#{current_user.username}"
    end
  end 

end 