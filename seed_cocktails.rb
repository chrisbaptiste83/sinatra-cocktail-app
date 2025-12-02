require 'net/http'
require 'json'
require 'sqlite3'
require 'bcrypt'

puts "🌱 Starting cocktail database seed..."

# Open database connection
db = SQLite3::Database.new 'db/development.sqlite'
db.results_as_hash = true

# Create admin user with bcrypt password
puts "\n👤 Creating admin user..."
admin_password = BCrypt::Password.create('admin123')

begin
  db.execute("INSERT INTO users (username, email, password_digest, created_at, updated_at)
              VALUES (?, ?, ?, datetime('now'), datetime('now'))",
             ['admin', 'admin@cocktails.com', admin_password.to_s])
  puts "✓ Admin user created: admin (admin@cocktails.com)"
  puts "  Login - Email: admin@cocktails.com, Password: admin123"
  admin_id = db.last_insert_row_id
rescue SQLite3::ConstraintException
  puts "✓ Admin user already exists"
  result = db.execute("SELECT id FROM users WHERE email = ?", ['admin@cocktails.com'])
  admin_id = result.first['id']
end

# Create demo user
puts "\n👤 Creating demo user..."
demo_password = BCrypt::Password.create('demo123')

begin
  db.execute("INSERT INTO users (username, email, password_digest, created_at, updated_at)
              VALUES (?, ?, ?, datetime('now'), datetime('now'))",
             ['demo_user', 'demo@cocktails.com', demo_password.to_s])
  puts "✓ Demo user created: demo_user (demo@cocktails.com)"
  puts "  Login - Email: demo@cocktails.com, Password: demo123"
  demo_id = db.last_insert_row_id
rescue SQLite3::ConstraintException
  puts "✓ Demo user already exists"
  result = db.execute("SELECT id FROM users WHERE email = ?", ['demo@cocktails.com'])
  demo_id = result.first['id']
end

# Fetch cocktails from TheCocktailDB API
puts "\n🍹 Fetching cocktails from TheCocktailDB API..."

cocktail_names = [
  'margarita', 'mojito', 'old fashioned', 'negroni', 'manhattan',
  'daiquiri', 'martini', 'cosmopolitan', 'whiskey sour', 'mai tai',
  'pina colada', 'bloody mary', 'moscow mule', 'gin and tonic', 'aperol spritz'
]

cocktails_created = 0

cocktail_names.each_with_index do |name, index|
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

      # Alternate between admin and demo user
      user_id = index.even? ? admin_id : demo_id
      username = index.even? ? 'admin' : 'demo_user'

      # Check if cocktail already exists
      existing = db.execute("SELECT id FROM cocktail_recipes WHERE cocktail_name = ? AND user_id = ?",
                           [drink['strDrink'], user_id])

      if existing.empty?
        # Add category info to instructions
        enhanced_instructions = "#{drink['strInstructions']} (#{drink['strCategory']} - #{drink['strGlass']})"

        db.execute("INSERT INTO cocktail_recipes
                   (cocktail_name, image_url, ingredients, instructions, user_id, created_at, updated_at)
                   VALUES (?, ?, ?, ?, ?, datetime('now'), datetime('now'))",
                  [drink['strDrink'], drink['strDrinkThumb'], ingredients.join(', '),
                   enhanced_instructions, user_id])

        cocktails_created += 1
        puts "  ✓ Created: #{drink['strDrink']} (by #{username})"
      else
        puts "  - Skipped: #{drink['strDrink']} (already exists)"
      end
    end

    # Be respectful to the API
    sleep 0.5

  rescue => e
    puts "  ✗ Error fetching #{name}: #{e.message}"
  end
end

# Get totals
user_count = db.execute("SELECT COUNT(*) as count FROM users")[0]['count']
cocktail_count = db.execute("SELECT COUNT(*) as count FROM cocktail_recipes")[0]['count']

puts "\n📊 Seed Summary:"
puts "  Total users in DB: #{user_count}"
puts "  New cocktails created: #{cocktails_created}"
puts "  Total cocktails in DB: #{cocktail_count}"

puts "\n✅ Database seeded successfully!"
puts "\n🔑 Login credentials:"
puts "  Admin: admin@cocktails.com / admin123"
puts "  Demo:  demo@cocktails.com / demo123"
puts "  Existing: chrisbaptiste83@gmail.com / (your password)"

db.close
