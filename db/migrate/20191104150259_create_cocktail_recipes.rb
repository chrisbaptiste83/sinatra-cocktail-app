class CreateCocktailRecipes < ActiveRecord::Migration
  def change
    create_table :cocktail_recipes do |t|

      t.timestamps null: false
    end
  end
end
