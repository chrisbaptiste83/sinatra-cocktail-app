class CocktailRecipesController < ApplicationController

  # GET: /cocktail_recipes
  get "/cocktail_recipes" do
    erb :"/cocktail_recipes/index.html"
  end

  # GET: /cocktail_recipes/new
  get "/cocktail_recipes/new" do
    erb :"/cocktail_recipes/new.html"
  end

  # POST: /cocktail_recipes
  post "/cocktail_recipes" do
    redirect "/cocktail_recipes"
  end

  # GET: /cocktail_recipes/5
  get "/cocktail_recipes/:id" do
    erb :"/cocktail_recipes/show.html"
  end

  # GET: /cocktail_recipes/5/edit
  get "/cocktail_recipes/:id/edit" do
    erb :"/cocktail_recipes/edit.html"
  end

  # PATCH: /cocktail_recipes/5
  patch "/cocktail_recipes/:id" do
    redirect "/cocktail_recipes/:id"
  end

  # DELETE: /cocktail_recipes/5/delete
  delete "/cocktail_recipes/:id/delete" do
    redirect "/cocktail_recipes"
  end
end
