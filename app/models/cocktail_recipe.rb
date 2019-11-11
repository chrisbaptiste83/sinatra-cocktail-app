class CocktailRecipe < ActiveRecord::Base 
    belongs_to :user 
    validates :cocktail_name, :ingredients, :instructions, presence: true
end
