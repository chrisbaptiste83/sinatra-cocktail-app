class CocktailRecipe < ActiveRecord::Base 
    belongs_to :user 
    validates :cocktail_name, :ingredients, :instructions, presence: true 
    has_many :comments 

 
   def created_at_date 
    self.created_at.strftime("%a %b %e %Y at %T") 
   end   

end
