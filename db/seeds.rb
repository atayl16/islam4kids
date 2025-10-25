# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create admin user
User.find_or_create_by!(email: 'admin@islam4kids.org') do |user|
  user.password = 'admin123456' # Change this in production!
  user.is_admin = true
end

# Create regular user
User.find_or_create_by!(email: 'user@islam4kids.org') do |user|
  user.password = 'user123456' # Change this in production!
  user.is_admin = false
end
