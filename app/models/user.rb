class User < ActiveRecord::Base
  has_secure_password
  validates :username, presence: true, uniqueness: true
  has_many :cocktail_recipes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def slug
    self.username
  end

  def self.find_by_slug(slug)
    User.find_by(username: slug)
  end
end
