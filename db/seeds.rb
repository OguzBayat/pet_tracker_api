# Pet Tracking API - Sample Data Seeds
# This file creates sample pets for testing and demonstration purposes

puts "🌱 Seeding Pet Tracking API database..."

# Clear existing data
Pet.destroy_all
puts "🗑️  Cleared existing pets"

# Create sample cats
puts "🐱 Creating sample cats..."

_cat1 = Cat.create!(
  tracker_type: 'small',
  owner_id: 1001,
  in_zone: true,
  lost_tracker: false
)

_cat2 = Cat.create!(
  tracker_type: 'big',
  owner_id: 1002,
  in_zone: false,
  lost_tracker: true
)

_cat3 = Cat.create!(
  tracker_type: 'small',
  owner_id: 1003,
  in_zone: false,
  lost_tracker: false
)

_cat4 = Cat.create!(
  tracker_type: 'big',
  owner_id: 1004,
  in_zone: true,
  lost_tracker: false
)

# Create sample dogs
puts "🐕 Creating sample dogs..."

_dog1 = Dog.create!(
  tracker_type: 'small',
  owner_id: 2001,
  in_zone: true,
  lost_tracker: false
)

_dog2 = Dog.create!(
  tracker_type: 'medium',
  owner_id: 2002,
  in_zone: false,
  lost_tracker: false
)

_dog3 = Dog.create!(
  tracker_type: 'big',
  owner_id: 2003,
  in_zone: false,
  lost_tracker: false
)

_dog4 = Dog.create!(
  tracker_type: 'medium',
  owner_id: 2004,
  in_zone: true,
  lost_tracker: false
)

_dog5 = Dog.create!(
  tracker_type: 'small',
  owner_id: 2005,
  in_zone: false,
  lost_tracker: false
)

# Display summary
total_pets = Pet.count
cats_count = Cat.count
dogs_count = Dog.count
pets_in_zone = Pet.in_zone.count
pets_outside_zone = Pet.outside_zone.count
cats_with_lost_tracker = Cat.where(lost_tracker: true).count

puts "✅ Seeding completed successfully!"
puts "📊 Summary:"
puts "   Total pets: #{total_pets}"
puts "   Cats: #{cats_count}"
puts "   Dogs: #{dogs_count}"
puts "   Pets in zone: #{pets_in_zone}"
puts "   Pets outside zone: #{pets_outside_zone}"
puts "   Cats with lost tracker: #{cats_with_lost_tracker}"

# Display sample statistics
puts "\n📈 Sample Statistics:"
puts "   Pets outside zone by type: #{Pet.pets_outside_zone_by_pet_type}"
puts "   Pets outside zone by tracker type: #{Pet.pets_outside_zone_by_tracker_type}"
puts "   Cats with lost tracker outside zone: #{Cat.cats_outside_zone_with_lost_tracker}"
puts "   Dogs outside zone by size: #{Dog.dogs_outside_zone_by_size}"

puts "\n🎯 You can now test the API with these sample pets!"
puts "   API Base URL: http://localhost:3000/api/v1"
puts "   Swagger Documentation: http://localhost:3000/swagger.html"
