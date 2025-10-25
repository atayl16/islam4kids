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

# Create sample blogs with Faker
if Blog.none?
  Rails.logger.debug 'Creating sample blogs...'

  # Create published blogs
  10.times do
    Blog.create!(
      title: Faker::Book.title,
      content: Faker::Lorem.paragraph(sentence_count: 10),
      status: 'published',
      created_at: Faker::Time.between(from: 30.days.ago, to: Time.current)
    )
  end

  # Create draft blogs
  3.times do
    Blog.create!(
      title: Faker::Book.title,
      content: Faker::Lorem.paragraph(sentence_count: 8),
      status: 'draft'
    )
  end

  # Create archived blogs
  2.times do
    Blog.create!(
      title: Faker::Book.title,
      content: Faker::Lorem.paragraph(sentence_count: 8),
      status: 'archived',
      created_at: Faker::Time.between(from: 60.days.ago, to: 30.days.ago)
    )
  end
end

# Create sample stories with Faker
if Story.none?
  Rails.logger.debug 'Creating sample stories...'

  # Create published stories
  10.times do
    Story.create!(
      title: Faker::Book.title,
      content: Faker::Lorem.paragraph(sentence_count: 12),
      status: 'published',
      created_at: Faker::Time.between(from: 30.days.ago, to: Time.current)
    )
  end

  # Create draft stories
  3.times do
    Story.create!(
      title: Faker::Book.title,
      content: Faker::Lorem.paragraph(sentence_count: 10),
      status: 'draft'
    )
  end

  # Create archived stories
  2.times do
    Story.create!(
      title: Faker::Book.title,
      content: Faker::Lorem.paragraph(sentence_count: 10),
      status: 'archived',
      created_at: Faker::Time.between(from: 60.days.ago, to: 30.days.ago)
    )
  end
end
