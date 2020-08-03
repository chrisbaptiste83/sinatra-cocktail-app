class AddDescriptionToCocktails < ActiveRecord::Migration
  def change 
    add_column :cocktail_recipes, :description, :text
  end
end
