class Comment < ActiveRecord::Base  
    belongs_to :user
    belongs_to :cocktail_recipe
end