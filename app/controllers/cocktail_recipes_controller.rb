class CocktailRecipesController < ApplicationController
  
  get "/cocktail_recipes" do
    redirect_if_not_logged_in
    @cocktail_recipes = CocktailRecipe.all
    erb :"/cocktail_recipes/index.html" 
  end

  
  get "/cocktail_recipes/new" do 
    redirect_if_not_logged_in
    erb :"/cocktail_recipes/new.html"  
  end

  
  post "/cocktail_recipes" do 
    if params[:cocktail_name].empty? || params[:ingredients].empty? || params[:instructions].empty? || params[:image_url].empty? || params[:description].empty? 
      flash[:message] = "Please complete all fields in order to upload a recipe."
      erb :"cocktail_recipes/new.html"
    else
      #@cocktail_recipe = CocktailRecipe.create(cocktail_name: params[:cocktail_name], ingredients: params[:ingredients], instructions: params[:instructions])
      #@cocktail_recipe.user = current_user 
      @cocktail_recipe = current_user.cocktail_recipes.build(cocktail_name: params[:cocktail_name], ingredients: params[:ingredients], instructions: params[:instructions], image_url: params[:image_url],description: params[:description])
      @cocktail_recipe.save 
      flash[:message] = "Your cocktail has been created."
      redirect "/cocktail_recipes/#{@cocktail_recipe.id}"
    end
  end

  get "/cocktail_recipes/:id" do 
    @cocktail_recipe = CocktailRecipe.find(params[:id]) 
    @comments = Comment.where("cocktail_recipe_id = #{@cocktail_recipe.id}") #all comments where post id is == the current post id
    erb :"/cocktail_recipes/show.html"
  end
   
  get "/cocktail_recipes/:id/edit" do 
    @cocktail_recipe = CocktailRecipe.find(params[:id]) 
      if @cocktail_recipe.user == current_user 
        erb :'/cocktail_recipes/edit.html' 
      else 
        flash[:message] = "You must be the cocktail recipe's owner in order to edit the recipe."
        redirect "/cocktail_recipes"
      end
  end

  patch "/cocktail_recipes/:id" do 
    @cocktail_recipe = CocktailRecipe.find(params[:id])
      if params[:cocktail_name].empty? || params[:ingredients].empty? || params[:instructions].empty? || params[:image_url].empty?
        flash[:message] = "Updated cocktail recipe must have all fields filled."
        redirect "/cocktail_recipes/#{@cocktail_recipe.id}/edit" 
      else
        @cocktail_recipe.update(cocktail_name: params[:cocktail_name], ingredients: params[:ingredients], instructions: params[:instructions], image_url: params[:image_url] ) 
        flash[:message] = "Your recipe has been updated."
        redirect "/cocktail_recipes"
      end
  end

  
  delete "/cocktail_recipes/:id/delete" do 
    @cocktail_recipe = CocktailRecipe.find(params[:id])
      if @cocktail_recipe.user_id == current_user.id
        @cocktail_recipe.destroy 
        flash[:message] = "Your recipe has been deleted."
        redirect "/cocktail_recipes"
      end 
  end 

end
