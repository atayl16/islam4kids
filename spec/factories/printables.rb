FactoryBot.define do
  factory :printable do
    title { 'Arabic Alphabet Flashcards' }
    description do
      'Printable Arabic alphabet flashcards to help children learn the letters. Perfect for young learners!'
    end
    printable_type { :worksheet }
    status { 'published' }

    # Attach files after build (for validations on unsaved records)
    after(:build) do |printable|
      # Attach files to unsaved record (Active Storage allows this)
      printable.pdf_file.attach(
        io: StringIO.new('%PDF-1.4 test content'),
        filename: 'test_printable.pdf',
        content_type: 'application/pdf'
      )
      printable.thumbnail_image.attach(
        io: StringIO.new("\x89PNG\r\n\x1A\n"),
        filename: 'test_thumbnail.png',
        content_type: 'image/png'
      )
    end

    # Override the to_create callback to handle file attachments with validations
    to_create do |instance|
      # If files aren't already attached (shouldn't happen with after(:build), but just in case)
      unless instance.pdf_file.attached?
        # Save without validation first to get an ID for file attachments
        instance.save!(validate: false)

        # Attach files
        instance.pdf_file.attach(
          io: StringIO.new('%PDF-1.4 test content'),
          filename: 'test_printable.pdf',
          content_type: 'application/pdf'
        )
        instance.thumbnail_image.attach(
          io: StringIO.new("\x89PNG\r\n\x1A\n"),
          filename: 'test_thumbnail.png',
          content_type: 'image/png'
        )
      end

      # Save with validation to ensure everything is correct
      instance.save!
    end

    # Factory variations for different types
    trait :ebook do
      title { 'Stories of the Prophets for Little Hearts' }
      printable_type { :ebook }
      description do
        'Get Your FREE Illustrated Book with engaging stories for children, ' \
          'includes parent guides and Quranic references.'
      end
    end

    trait :journal do
      title { 'Ramadan Gratitude Journal for Kids' }
      printable_type { :journal }
      description do
        'A different prompt daily to encourage your child to write or draw about things they are grateful for.'
      end
    end

    trait :activity do
      title { 'Ramadan Activity Book for Kids' }
      printable_type { :activity }
      description { 'This Ramadan themed activity book has mazes, coloring pages, and more!' }
    end

    trait :draft do
      status { 'draft' }
    end
  end
end
