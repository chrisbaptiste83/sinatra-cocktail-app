class CocktailRecipesController < ApplicationController
  # GET: /cocktail_recipes
  get "/cocktail_recipes" do
    if logged_in?
      @user = current_user 
      @cocktail_recipes = CocktailRecipe.all
      erb :"/cocktail_recipes/index.html" 
    else 
      redirect to '/login'
    end

  end

  # GET: /cocktail_recipes/new
  get "/cocktail_recipes/new" do 
    if logged_in?
      erb :"/cocktail_recipes/new.html"  
    else
      redirect to '/login'
    end
  end

  # POST: /cocktail_recipes
    post "/cocktail_recipes" do 
    if params[:cocktail_name] == "" 
      flash[:message] = "Cocktail name cannot be blank. Please enter a cocktail name and complete all fields."
      erb :"cocktail_recipes/new.html"
    else
     @cocktail_recipe = CocktailRecipe.create(params)
     @cocktail_recipe.user = current_user 
     @cocktail_recipe.save 
     flash[:message] = "Your cocktail has been created."
     redirect "/cocktail_recipes/#{@cocktail_recipe.id}"
      end
    end


  # GET: /cocktail_recipes/5
  get "/cocktail_recipes/:id" do 
    @cocktail_recipe = CocktailRecipe.find(params[:id]) 
    erb :"/cocktail_recipes/show.html"
  end
   
  # GET: /cocktail_recipes/5/edit
  get "/cocktail_recipes/:id/edit" do 
    @cocktail_recipe = CocktailRecipe.find(params[:id])
               
         if @cocktail_recipe.user == current_user 
            erb :'/cocktail_recipes/edit.html' 
         else 
          flash[:message] = "You must be the cocktail recipe's owner in order to edit the recipe."
          redirect "/cocktail_recipes"
        end
      end

  # PATCH: /cocktail_recipes/5
  patch "/cocktail_recipes/:id" do 
    @cocktail_recipe = current_user.cocktail_recipes.find(params[:id])
        if params[:cocktail_recipe] != ""
          @cocktail_recipe.update(params[:cocktail_recipe]) 
          flash[:message] = "Your recipe has been updated."
          redirect "/cocktail_recipes"
        else
          redirect "/cocktail_recipes/#{@cocktail_recipe.id}/edit"
        end
     end

  # DELETE: /cocktail_recipes/5/delete
  delete "/cocktail_recipes/:id/delete" do 
    @cocktail_recipe = CocktailRecipe.find(params[:id])
          if @cocktail_recipe.user_id == current_user.id
            @cocktail_recipe.destroy 
            flash[:message] = "Your recipe has been deleted."
            redirect "/cocktail_recipes"
          else
            redirect "/cocktail_recipes"
         end
        end
   
end
