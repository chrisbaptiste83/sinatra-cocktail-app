
class CommentsController < ApplicationController

  get '/cocktail_recipes/:cocktail_recipe_id/comments/new' do 
    @cocktail_recipe = CocktailRecipe.find_by_id(params[:cocktail_recipe_id])
    erb :'comments/new.html'
  end

  post '/cocktail_recipes/:cocktail_recipe_id/comments' do  
    cocktail_recipe_id = params[:cocktail_recipe_id]
    if params[:comment][:content] == ""
      flash[:message] = "Content cannot be blank!"
      redirect to "/cocktaiil_recipes/#{cocktail_recipe_id}/comments/new"
    else
      comment = params[:comment]
      comment[:cocktail_recipe_id] = params[:cocktail_recipe_id]
      comment[:user_id] = session[:user_id]
      @comment = Comment.create(comment)
      @comment.save
    end
    redirect to "/cocktail_recipes/#{cocktail_recipe_id}/comments/#{@comment.id}"
  end

  get '/cocktail_recipes/:cocktail_recipe_id/comments/:comment_id' do 
    if logged_in?
      @cocktail_recipe_id = params[:cocktail_recipe_id]
      @comment = Comment.find_by_id(params[:comment_id])
      @time_ago = Time.now - @comment.updated_at
      erb :'comments/show.html'
    else
      redirect_if_not_logged_in
    end
  end

  get '/cocktail_recipes/:cocktail_recipe_id/comments/:comment_id/edit' do 
    if logged_in?
      @cocktail_recipe_id = params[:cocktail_recipe_id]
      @comment = Comment.find_by_id(params[:comment_id])
      if @comment.user_id == current_user.id
        erb :'comments/edit.html'
      else
        redirect to "/cocktail_recipes/#{@cocktail_recipe_id}" 
      end
    else
      redirect_if_not_logged_in
    end
  end

  patch '/cocktail_recipes/:cocktail_recipe_id/comments/:comment_id' do 
    if logged_in?
      @cocktail_recipe_id = params[:cocktail_recipe_id]
      @comment = Comment.find_by_id(params[:comment_id])
      if params[:comment][:content] == ""
        flash[:message] = "Content cannot be blank!"
        redirect to "/cocktail_recipes/#{@cocktail_recipe_id}/comments/#{@comment.id}/edit"
      else
        @comment.update(params[:comment])
        @comment.save
        redirect to "/cocktail_recipes/#{@cocktail_recipe_id}/comments/#{@comment.id}"
      end
    else
      redirect_if_not_logged_in
    end
  end
  
  delete '/cocktail_recipes/:cocktail_recipes_id/comments/:comment_id/delete' do
    if logged_in?
      @cocktail_recipe_id = params[:cocktail_recipe_id]
      @comment = Comment.find_by_id(params[:comment_id])
      if @comment.user_id == current_user.id
        @comment.delete
        redirect to "/cocktail_recipes/#{@cocktail_recipe_id}" 
      else
        redirect to "/posts/#{@post_id}" 
      end
    else
      redirect_if_not_logged_in
    end
  end
end 