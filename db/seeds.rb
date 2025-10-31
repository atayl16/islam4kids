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

# Helper method to attach files to printables
def attach_printable_files(printable, title)
  pdf_content = "%PDF-1.4\n1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj " \
                '2 0 obj<</Type/Pages/Kids[3 0 R]/Count 1>>endobj ' \
                "3 0 obj<</Type/Page/MediaBox[0 0 612 792]/Parent 2 0 R/Resources<<>>>>endobj\n" \
                "xref\n0 4\ntrailer<</Size 4/Root 1 0 R>>\nstartxref\n149\n%%EOF"
  printable.pdf_file.attach(
    io: StringIO.new(pdf_content),
    filename: "#{title.parameterize}.pdf",
    content_type: 'application/pdf'
  )

  # Create a simple 1x1 pixel PNG
  png_content = "\x89PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01" \
                "\b\x02\x00\x00\x00\x90wS\xDE\x00\x00\x00\fIDATx\x9Cc\x00\x01\x00\x00" \
                "\x05\x00\x01\r\n-\xB4\x00\x00\x00\x00IEND\xAEB`\x82"
  printable.thumbnail_image.attach(
    io: StringIO.new(png_content),
    filename: "#{title.parameterize}-thumbnail.png",
    content_type: 'image/png'
  )
end

# Create sample printables
if Printable.none?
  Rails.logger.debug 'Creating sample printables...'

  printable_data = [
    {
      title: 'Arabic Alphabet Flashcards',
      description: 'Arabic alphabet flashcards in printable PDF format. Perfect for young learners!',
      printable_type: :flashcard,
      status: 'published'
    },
    {
      title: 'Ramadan Gratitude Journal for Kids',
      description: 'A different prompt daily to encourage your child to write or draw about ' \
                   'things they are grateful for.',
      printable_type: :journal,
      status: 'published'
    },
    {
      title: 'Names of Allah - Workbook',
      description: 'This workbook briefly reviews some of the names of Allah and has ' \
                   'activities, such as word searches, fill in the blank, and questions to ' \
                   'reinforce learning.',
      printable_type: :worksheet,
      status: 'published'
    },
    {
      title: 'Stories of the Prophets for Little Hearts',
      description: 'Get Your FREE Illustrated Book with 20 pages of engaging stories for ' \
                   'children, includes parent guides and Quranic references.',
      printable_type: :ebook,
      status: 'published'
    },
    {
      title: 'Ramadan Activity Book for Kids',
      description: 'This Ramadan themed activity book has mazes, coloring pages, and more!',
      printable_type: :activity,
      status: 'published'
    },
    {
      title: 'Ramadan Tracker & Planner',
      description: 'Printable Ramadan tracker and planner in convenient PDF format.',
      printable_type: :planner,
      status: 'published'
    },
    {
      title: 'Salat Movements For Kids Poster',
      description: 'Printable infographic that helps kids remember the steps of the prayer.',
      printable_type: :poster,
      status: 'published'
    },
    {
      title: 'Shahadah Certificate',
      description: "Fill in this certificate with your child's name to recognize that they " \
                   'learned and said the Shahadah.',
      printable_type: :certificate,
      status: 'published'
    },
    {
      title: 'Weekly Prayer Tracker',
      description: 'Convenient printable prayer tracker helps you track the 5 daily prayers for a week!',
      printable_type: :tracker,
      status: 'published'
    },
    {
      title: 'Stories of the Sahabah for Little Muslims - DRAFT',
      description: 'This ebook is still being finalized.',
      printable_type: :ebook,
      status: 'draft'
    }
  ]

  printable_data.each do |data| # rubocop:disable Metrics/BlockLength
    # Create printable without validation first (files need to be attached after creation)
    printable = Printable.new(
      title: data[:title],
      description: data[:description],
      printable_type: data[:printable_type],
      status: data[:status],
      published_at: data[:status] == 'published' ? Faker::Time.between(from: 30.days.ago, to: Time.current) : nil
    )

    # Save without validation to get an ID for file attachments
    printable.save!(validate: false)

    # Attach dummy files for each printable
    attach_printable_files(printable, data[:title])

    # Now save with validation to ensure everything is correct
    printable.save!

    Rails.logger.debug { "  Created printable: #{printable.title}" }
  end

  Rails.logger.debug { "Created #{Printable.count} printables" }
end
