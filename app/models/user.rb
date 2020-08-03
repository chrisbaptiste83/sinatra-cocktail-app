class User < ActiveRecord::Base 
    has_secure_password
    validates :username, presence: true, uniqueness: true
    has_many :cocktail_recipes 
    has_many :comments 

    def slug
        self.username
      end
    
    def self.find_by_slug(slug) 
        User.all.find{|user| user.slug == slug}
    end
end
