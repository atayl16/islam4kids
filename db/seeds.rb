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

# Create sample stories with realistic Islamic content
if Story.none?
  Rails.logger.debug 'Creating sample stories...'

  story_data = [
    {
      title: 'Prophet Yunus (AS) and the Whale',
      summary: 'Discover the story of Prophet Yunus (AS), who was swallowed by a giant whale! Learn how patience and dua can save us even in the darkest times.',
      content: "The Prophet's Mission\n\nProphet Yunus (AS) was sent to teach the people of Nineveh to worship Allah alone. But they refused to listen! Frustrated, Yunus (AS) left the city without Allah's permission.\n\nThe Storm and the Whale\n\nA storm sank the ship he boarded, and Yunus (AS) was swallowed by a giant whale! In the whale's dark belly, he prayed: \"La ilaha illa Anta, Subhanaka! (There is no god but You, Glory be to You!)\" (Quran 21:87).\n\nA Second Chance\n\nAllah forgave Yunus (AS) and commanded the whale to spit him onto shore. When he returned to Nineveh, he was amazed—the people had finally accepted Islam!",
      status: 'published'
    },
    {
      title: 'The Story of Prophet Ibrahim (AS)',
      summary: 'Learn about Prophet Ibrahim (AS) and his unwavering faith in Allah, including his willingness to sacrifice his son Ismail.',
      content: "Prophet Ibrahim (AS) was known for his complete trust in Allah. When Allah tested him by asking him to sacrifice his son Ismail, Ibrahim (AS) showed his faith by being ready to obey Allah's command. At the last moment, Allah replaced Ismail with a ram, showing that Allah never wants harm—only our obedience and trust.",
      status: 'published'
    },
    {
      title: 'The Honest Shepherd',
      summary: 'A beautiful story about honesty and trustworthiness that teaches children the importance of keeping promises.',
      content: "Once upon a time, there was a young shepherd who watched over the sheep. Every day, he would call for help even when there was no danger. The villagers came running but found no wolf. One day, when a real wolf appeared, the shepherd called for help, but no one believed him. This story teaches us that honesty is the best policy and that we should always tell the truth.",
      status: 'published'
    },
    {
      title: 'The Boy and the King',
      summary: 'An inspiring tale about courage and standing up for what is right, even when facing great power.',
      content: "A young boy once stood up to a powerful king who claimed to be a god. The boy, with unwavering faith in Allah, refused to worship anyone but Allah. Despite the king's threats, the boy remained firm in his beliefs. His courage inspired others to also stand up for the truth.",
      status: 'published'
    },
    {
      title: 'The Blessed Rain',
      summary: 'A gentle story about gratitude and recognizing Allah\'s blessings in everyday life.',
      content: "When a village experienced a long drought, the people prayed for rain. Allah answered their prayers with blessed rain that saved their crops and brought life back to their land. This story reminds us to be grateful for Allah's blessings and to remember that He always answers our prayers in His own perfect time.",
      status: 'published'
    },
    {
      title: 'The Generous Merchant',
      summary: 'Learn about generosity and sharing with others through the example of a kind-hearted merchant.',
      content: "A wealthy merchant used to help the poor and needy in his town. He would give food, clothing, and shelter to those in need without expecting anything in return. His generosity spread throughout the land, and people learned that giving brings more happiness than receiving.",
      status: 'published'
    },
    {
      title: 'The Night Journey',
      summary: 'Discover the miraculous journey of Prophet Muhammad (PBUH) from Makkah to Jerusalem and then to the heavens.',
      content: "One night, Prophet Muhammad (PBUH) was taken on an incredible journey known as Al-Isra wal-Miraj. He traveled from Makkah to Jerusalem on a special mount called Buraq, and then ascended through the seven heavens to meet Allah. This journey shows us the special status of Prophet Muhammad (PBUH) and the importance of prayer in Islam.",
      status: 'published'
    },
    {
      title: 'The First Mosque',
      summary: 'The story of how the first mosque was built in Islam, teaching children about the importance of places of worship.',
      content: "When Prophet Muhammad (PBUH) migrated to Madinah, one of the first things he did was help build a mosque. All the Muslims worked together—some carried stones, some carried bricks, and everyone helped. This story teaches us about unity, cooperation, and the importance of having a place to pray and learn about Islam together.",
      status: 'published'
    },
    {
      title: 'The Kindness of a Sahabah',
      summary: 'A heartwarming story about the companions of the Prophet and their acts of kindness.',
      content: "The companions of Prophet Muhammad (PBUH) were known for their kindness and good character. This story follows one of them as he helps an elderly neighbor, feeds the hungry, and shows compassion to everyone he meets. Their example inspires us to be better people every day.",
      status: 'published'
    },
    {
      title: 'Ramadan in Old Times',
      summary: 'Experience how Muslims celebrated Ramadan in the past and learn about traditions that continue today.',
      content: "Long ago, Muslims would prepare for Ramadan weeks in advance. They would make special foods, clean their homes, and gather with family. During Ramadan, the whole community would come together for iftar and tarawih prayers. This story helps children understand the beauty and community spirit of Ramadan.",
      status: 'published'
    },
    {
      title: 'The Quest for Knowledge',
      summary: 'An inspiring story about the importance of seeking knowledge in Islam.',
      content: "A young student travels far and wide to learn from the greatest scholars of his time. He faces many challenges but never gives up. This story teaches children that seeking knowledge is an important part of being a good Muslim and that learning is a lifelong journey.",
      status: 'draft'
    },
    {
      title: 'The Garden of Paradise',
      summary: 'A beautiful story describing what Paradise might be like, based on descriptions in the Quran.',
      content: "Through simple words and vivid imagery, this story helps children understand the beauty of Jannah (Paradise). It describes rivers of milk and honey, beautiful gardens, and the joy of being close to Allah. The story encourages children to do good deeds to earn Allah's pleasure.",
      status: 'draft'
    },
    {
      title: 'The Story of Creation',
      summary: 'A gentle introduction to how Allah created the world, suitable for young children.',
      content: "This story tells how Allah created everything—the sky, the earth, the sun, the moon, the stars, the animals, and finally, human beings. It emphasizes that Allah created everything with purpose and wisdom, and that we should appreciate and take care of His creation.",
      status: 'archived'
    }
  ]

  story_data.each do |data|
    story = Story.create!(
      title: data[:title],
      summary: data[:summary],
      content: data[:content],
      status: data[:status],
      created_at: data[:status] == 'published' ? Faker::Time.between(from: 30.days.ago, to: Time.current) : nil
    )
    Rails.logger.debug { "  Created story: #{story.title}" }
  end

  Rails.logger.debug { "Created #{Story.count} stories" }
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
      status: data[:status]
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
