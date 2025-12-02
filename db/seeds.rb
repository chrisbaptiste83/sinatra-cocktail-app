require 'net/http'
require 'json'

puts "🌱 Starting database seed..."

# Create Admin User
puts "\n👤 Creating admin user..."
admin = User.find_or_create_by(email: 'admin@cocktails.com') do |u|
  u.username = 'admin'
  u.password = 'admin123'
  u.password_confirmation = 'admin123'
end

if admin.persisted?
  puts "✓ Admin user created: #{admin.username} (#{admin.email})"
  puts "  Login credentials - Email: admin@cocktails.com, Password: admin123"
else
  puts "✗ Failed to create admin user: #{admin.errors.full_messages.join(', ')}"
end

# Create a regular demo user
puts "\n👤 Creating demo user..."
demo_user = User.find_or_create_by(email: 'demo@cocktails.com') do |u|
  u.username = 'demo_user'
  u.password = 'demo123'
  u.password_confirmation = 'demo123'
end

if demo_user.persisted?
  puts "✓ Demo user created: #{demo_user.username} (#{demo_user.email})"
  puts "  Login credentials - Email: demo@cocktails.com, Password: demo123"
else
  puts "✗ Failed to create demo user: #{demo_user.errors.full_messages.join(', ')}"
end

# Fetch cocktails from TheCocktailDB API
puts "\n🍹 Fetching cocktails from TheCocktailDB API..."

# Popular cocktails to search for
cocktail_names = [
  'margarita', 'mojito', 'old fashioned', 'negroni', 'manhattan',
  'daiquiri', 'martini', 'cosmopolitan', 'whiskey sour', 'mai tai',
  'pina colada', 'bloody mary', 'moscow mule', 'gin and tonic', 'aperol spritz'
]

cocktails_created = 0

cocktail_names.each do |name|
  begin
    # Fetch from API
    uri = URI("https://www.thecocktaildb.com/api/json/v1/1/search.php?s=#{URI.encode_www_form_component(name)}")
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    if data['drinks'] && data['drinks'].any?
      drink = data['drinks'].first

      # Build ingredients list
      ingredients = []
      (1..15).each do |i|
        ingredient = drink["strIngredient#{i}"]
        measure = drink["strMeasure#{i}"]

        if ingredient && !ingredient.empty?
          ingredients << "#{measure&.strip} #{ingredient}".strip
        end
      end

      # Create cocktail recipe - alternate between admin and demo user
      user = cocktails_created.even? ? admin : demo_user

      cocktail = CocktailRecipe.find_or_create_by(
        cocktail_name: drink['strDrink'],
        user_id: user.id
      ) do |c|
        c.image_url = drink['strDrinkThumb']
        c.ingredients = ingredients.join(', ')
        c.instructions = drink['strInstructions']
        c.description = "A #{drink['strCategory']} cocktail served in a #{drink['strGlass']}. #{drink['strAlcoholic']}."
      end

      if cocktail.persisted?
        cocktails_created += 1
        puts "  ✓ Created: #{drink['strDrink']} (by #{user.username})"
      end
    end

    # Be respectful to the API
    sleep 0.5

  rescue => e
    puts "  ✗ Error fetching #{name}: #{e.message}"
  end
end

puts "\n📊 Seed Summary:"
puts "  Users created: #{User.count}"
puts "  Cocktails created: #{cocktails_created}"
puts "  Total cocktails in DB: #{CocktailRecipe.count}"

puts "\n✅ Database seeded successfully!"
puts "\n🔑 Login credentials:"
puts "  Admin: admin@cocktails.com / admin123"
puts "  Demo:  demo@cocktails.com / demo123"
