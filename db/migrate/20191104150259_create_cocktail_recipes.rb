class CreateCocktailRecipes < ActiveRecord::Migration
  def change
    create_table :cocktail_recipes do |t|
        t.string :cocktail_name 
        t.string :image_url
        t.string :ingredients
        t.text :instructions
        t.integer :user_id
      t.timestamps null: false
    end
  end
end
