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
# Skip in test environment - users should be created via factories in tests
unless Rails.env.test?
  User.find_or_create_by!(email: 'admin@islam4kids.org') do |user|
    user.password = 'admin123456' # Change this in production!
    user.is_admin = true
  end

  # Create regular user
  User.find_or_create_by!(email: 'user@islam4kids.org') do |user|
    user.password = 'user123456' # Change this in production!
    user.is_admin = false
  end
end

# Create sample stories with realistic Islamic content
# Skip sample data in test environment
if Story.none? && !Rails.env.test?
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
      content: 'Once upon a time, there was a young shepherd who watched over the sheep. Every day, he would call for help even when there was no danger. The villagers came running but found no wolf. One day, when a real wolf appeared, the shepherd called for help, but no one believed him. This story teaches us that honesty is the best policy and that we should always tell the truth.',
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
      content: 'A wealthy merchant used to help the poor and needy in his town. He would give food, clothing, and shelter to those in need without expecting anything in return. His generosity spread throughout the land, and people learned that giving brings more happiness than receiving.',
      status: 'published'
    },
    {
      title: 'The Night Journey',
      summary: 'Discover the miraculous journey of Prophet Muhammad (PBUH) from Makkah to Jerusalem and then to the heavens.',
      content: 'One night, Prophet Muhammad (PBUH) was taken on an incredible journey known as Al-Isra wal-Miraj. He traveled from Makkah to Jerusalem on a special mount called Buraq, and then ascended through the seven heavens to meet Allah. This journey shows us the special status of Prophet Muhammad (PBUH) and the importance of prayer in Islam.',
      status: 'published'
    },
    {
      title: 'The First Mosque',
      summary: 'The story of how the first mosque was built in Islam, teaching children about the importance of places of worship.',
      content: 'When Prophet Muhammad (PBUH) migrated to Madinah, one of the first things he did was help build a mosque. All the Muslims worked together—some carried stones, some carried bricks, and everyone helped. This story teaches us about unity, cooperation, and the importance of having a place to pray and learn about Islam together.',
      status: 'published'
    },
    {
      title: 'The Kindness of a Sahabah',
      summary: 'A heartwarming story about the companions of the Prophet and their acts of kindness.',
      content: 'The companions of Prophet Muhammad (PBUH) were known for their kindness and good character. This story follows one of them as he helps an elderly neighbor, feeds the hungry, and shows compassion to everyone he meets. Their example inspires us to be better people every day.',
      status: 'published'
    },
    {
      title: 'Ramadan in Old Times',
      summary: 'Experience how Muslims celebrated Ramadan in the past and learn about traditions that continue today.',
      content: 'Long ago, Muslims would prepare for Ramadan weeks in advance. They would make special foods, clean their homes, and gather with family. During Ramadan, the whole community would come together for iftar and tarawih prayers. This story helps children understand the beauty and community spirit of Ramadan.',
      status: 'published'
    },
    {
      title: 'The Quest for Knowledge',
      summary: 'An inspiring story about the importance of seeking knowledge in Islam.',
      content: 'A young student travels far and wide to learn from the greatest scholars of his time. He faces many challenges but never gives up. This story teaches children that seeking knowledge is an important part of being a good Muslim and that learning is a lifelong journey.',
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
      content: 'This story tells how Allah created everything—the sky, the earth, the sun, the moon, the stars, the animals, and finally, human beings. It emphasizes that Allah created everything with purpose and wisdom, and that we should appreciate and take care of His creation.',
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
# Skip sample data in test environment
if Printable.none? && !Rails.env.test?
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

  printable_data.each do |data|
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

# Create sample games
# Skip sample data in test environment
if Game.none? && !Rails.env.test?
  Rails.logger.debug 'Creating sample games...'

  game_data = [
    {
      title: 'Arabic Alphabet Match',
      description: 'Match Arabic letters with their sounds and names. Great for beginners!',
      game_url: 'https://wordwall.net/resource/12345678/arabic-alphabet',
      source_attribution: 'Wordwall',
      status: 'published'
    },
    {
      title: 'Prophet Names Quiz',
      description: 'Test knowledge of Prophet names from the Quran. Multiple choice for all ages.',
      game_url: 'https://wordwall.net/resource/12345679/prophet-names',
      source_attribution: 'Wordwall',
      status: 'published'
    },
    {
      title: 'Daily Duas Flashcards',
      description: 'Learn important daily duas with interactive flashcards. Audio included for proper pronunciation.',
      game_url: 'https://wordwall.net/resource/12345680/daily-duas',
      source_attribution: 'Wordwall',
      status: 'published'
    },
    {
      title: 'Pillars of Islam Match',
      description: 'Match the Five Pillars of Islam with their descriptions and meanings.',
      game_url: 'https://wordwall.net/resource/12345681/pillars-islam',
      source_attribution: 'Wordwall',
      status: 'published'
    },
    {
      title: 'Prayer Positions Game',
      description: 'Learn the positions of Salah (prayer) through an interactive sequencing game.',
      game_url: 'https://wordwall.net/resource/12345682/prayer-positions',
      source_attribution: 'Wordwall',
      status: 'published'
    },
    {
      title: 'Quranic Animals Quiz',
      description: 'Discover the different animals mentioned in the Quran through fun quiz questions.',
      game_url: 'https://wordwall.net/resource/12345683/quranic-animals',
      source_attribution: 'Wordwall',
      status: 'published'
    },
    {
      title: 'Ramadan Vocabulary Hunt',
      description: 'Word search game with important Ramadan-related vocabulary and terms.',
      game_url: 'https://wordwall.net/resource/12345684/ramadan-words',
      source_attribution: 'Wordwall',
      status: 'published'
    },
    {
      title: 'Islamic Months Memory Game',
      description: 'Memory card game to learn the names of the twelve Islamic months.',
      game_url: 'https://wordwall.net/resource/12345685/islamic-months',
      source_attribution: 'Wordwall',
      status: 'published'
    },
    {
      title: 'Prophet Stories Sequencing',
      description: 'Put the events of Prophet Yusuf\'s story in the correct order. Beautiful illustrations included!',
      game_url: 'https://wordwall.net/resource/12345686/prophet-yusuf',
      source_attribution: 'Wordwall',
      status: 'published'
    },
    {
      title: '99 Names of Allah Quiz',
      description: 'Advanced quiz covering the beautiful names of Allah (Asma ul Husna). Perfect for older kids!',
      game_url: 'https://wordwall.net/resource/12345687/names-of-allah',
      source_attribution: 'Wordwall',
      status: 'published'
    },
    {
      title: 'Hajj Journey Game',
      description: 'Interactive map-based game to learn about the rites and places of Hajj.',
      game_url: 'https://wordwall.net/resource/12345688/hajj-journey',
      source_attribution: 'Wordwall',
      status: 'draft'
    },
    {
      title: 'Islamic Calendar Puzzle',
      description: 'Put together the Islamic lunar calendar and learn about special days in each month.',
      game_url: 'https://wordwall.net/resource/12345689/calendar-puzzle',
      source_attribution: 'Wordwall',
      status: 'archived'
    }
  ]

  game_data.each do |data|
    # Create game without validation first (thumbnail needs to be attached after)
    game = Game.new(
      title: data[:title],
      description: data[:description],
      game_url: data[:game_url],
      source_attribution: data[:source_attribution],
      status: data[:status]
    )

    # Save without validation to get an ID for file attachments
    game.save!(validate: false)

    # Attach dummy thumbnail image
    png_content = "\x89PNG\r\n\x1A\n\x00\x00\x00\rIHDR\x00\x00\x00\x01\x00\x00\x00\x01" \
                  "\b\x02\x00\x00\x00\x90wS\xDE\x00\x00\x00\fIDATx\x9Cc\x00\x01\x00\x00" \
                  "\x05\x00\x01\r\n-\xB4\x00\x00\x00\x00IEND\xAEB`\x82"
    game.thumbnail_image.attach(
      io: StringIO.new(png_content),
      filename: "#{data[:title].parameterize}-thumbnail.png",
      content_type: 'image/png'
    )

    # Now save with validation to ensure everything is correct
    game.save!

    Rails.logger.debug { "  Created game: #{game.title}" }
  end

  Rails.logger.debug { "Created #{Game.count} games" }
end

# Create sample videos
# Skip sample data in test environment

if Video.none? && !Rails.env.test?
  Rails.logger.debug 'Creating sample videos...'

  video_data = [
    {
      title: "WHAT is the QURAN? | The Story of the Quran and it's IMPORTANCE for Kids | Islamic Kids National",
      description: "A video about the Quran and its importance for kids.",
      video_url: "https://youtu.be/tr7aZowQxUc",
      featured: true,
      position: 1,
      status: 'published'
    },
    {
      title: "Nasheed - Prophet Yunus (Jonah) Song for Children with Zaky",
      description: "A video about the Prophet Yunus (Jonah) song for children.",
      video_url: "https://youtu.be/CSoCd1Q-z_8",
      featured: true,
      position: 2,
      status: 'published'
    },
    {
      title: "The Story of Prophet Yunus (as) With Zaky - Muslim Cartoon",
      description: "A video about the Prophet Yunus (as) story with Zaky.",
      video_url: "https://youtu.be/c2I-MdrBkUY",
      featured: true,
      position: 3,
      status: 'published'
    },
    {
      title: "Why Do We Fast in Ramadan?: Ramadan Lessons | Islamic Cartoon | IQRA Cartoon",
      description: "A video about the importance of fasting in Ramadan.",
      video_url: "https://youtu.be/s1t4180kKk4",
      featured: true,
      position: 4,
      status: 'published'
    },
    {
      title: "Creative Kids: My First Fast",
      description: "A video about the first fast of a child.",
      video_url: "https://youtu.be/ykC1xvPSmTY",
      featured: true,
      position: 5,
      status: 'published'
    },
    {
      title: "What Is Zakat? (ep13) - Ramadan Reminders With Zaky 🌙",
      description: "A video about the importance of Zakat in Ramadan.",
      video_url: "https://youtu.be/-gnKsPyp8TQ",
      featured: true,
      position: 6,
      status: 'published'
    }, 
    {
      title: "LEARN the 5 Pillars of ISLAM with ZAKY",
      description: "A video about the 5 Pillars of Islam.",
      video_url: "https://youtu.be/mWJ-tlZdtK4",
      featured: true,
      position: 7,
      status: 'published'
    },
    {
      title: "Saying the Shahadah! Learning with ZAKY",
      description: "A video about the Shahadah.",
      video_url: "https://youtu.be/t2OepFfxZVI",
      featured: true,
      position: 8,
      status: 'published'
    },
    {
      title: "5 Pillars of Islam - part 1&2 | Cartoon by Discover Islam UK",
      description: "A video about the 5 Pillars of Islam.",
      video_url: "https://youtu.be/H80ecWSbu9E",
      featured: true,
      position: 9,
      status: 'published'
    },
    {
      title: "What is Hajj? | Hajj for Kids | Zill Noorain #hajj2023 #kidslearning #Islam",
      description: "A video about the Hajj.",
      video_url: "https://youtu.be/E0flOw0xxBY",
      featured: true,
      position: 10,
      status: 'published'
    },
    {
      title: "How to pray 3 Rakat (units) - Step by Step Guide | From Time to Pray with Zaky",
      description: "A video about the how to pray 3 Rakat (units).",
      video_url: "https://youtu.be/dp3Cj0fLBOE",
      featured: true,
      position: 11,
      status: 'published'
    },
    {
      title: "How to pray 2 Rakat (units) - Step by Step Guide | From Time to Pray with Zaky",
      description: "A video about the how to pray 2 Rakat (units).",
      video_url: "https://youtu.be/WZk197Rf5LQ",
      featured: true,
      position: 12,
      status: 'published'
    },
    {
      title: "How to pray 4 Rakat (units) - Step by Step Guide | From Time to Pray with Zaky",
      description: "A video about the how to pray 4 Rakat (units).",
      video_url: "https://youtu.be/f6iR5elhDdk",
      featured: true,
      position: 13,
      status: 'published'
    },
    {
      title: "TIME TO PRAY WITH ZAKY - FULL MOVIE FOR KIDS",
      description: "A video about the time to pray with Zaky.",
      video_url: "https://youtu.be/i0eSf7oYsXE",
      featured: true,
      position: 14,
      status: 'published'
    },
    {
      title: "Creative Kids: I Hit My Sister",
      description: "A video about the creative kids: I hit my sister.",
      video_url: "https://youtu.be/4Di9e1Q4bgQ",
      featured: false,
      position: 15,
      status: 'published'
    },
    {
      title: "Creative Kids: Michael and the Ants",
      description: "A video about the creative kids: Michael and the ants.",
      video_url: "https://youtu.be/UcpFglJAKQo",
      featured: false,
      position: 16,
      status: 'published'
    },
    {
      title: "Creative Kids Season 2 Gashee",
      description: "A video about the creative kids season 2 gashee.",
      video_url: "https://youtu.be/KweoVxaVxc0",
      featured: false,
      position: 17,
      status: 'published'
    },
    {
      title: "Creative Kids Season 2 Allah's Kindness",
      description: "A video about the creative kids season 2 Allah's kindness.",
      video_url: "https://youtu.be/ld4mWXjERvY",
      featured: false,
      position: 18,
      status: 'published'
    }
  ]

  video_data.each do |data|
    video = Video.create!(
      title: data[:title],
      description: data[:description],
      video_url: data[:video_url],
      featured: data[:featured],
      position: data[:position],
      status: data[:status]
    )
    Rails.logger.debug { "  Created video: #{video.title}" }
  end

  Rails.logger.debug { "Created #{Video.count} videos" }
end
