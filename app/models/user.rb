class User < ActiveRecord::Base 
    has_secure_password
    validates_presence_of :username, :email, :password
    validates :username, :uniqueness => {:case_sensitive => false}
     
    has_many :cocktail_recipes
end
