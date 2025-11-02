FactoryBot.define do
  factory :game do
    title { 'Arabic Alphabet Match' }
    description do
      'Match Arabic letters with their sounds and names. Great for beginners!'
    end
    game_url { 'https://wordwall.net/resource/12345678/arabic-alphabet' }
    source_attribution { 'Wordwall' }
    status { 'published' }

    # Attach thumbnail after build
    after(:build) do |game|
      game.thumbnail_image.attach(
        io: StringIO.new("\x89PNG\r\n\x1A\n"),
        filename: 'test_thumbnail.png',
        content_type: 'image/png'
      )
    end

    # Override the to_create callback to handle file attachments with validations
    to_create do |instance|
      # If thumbnail isn't already attached (shouldn't happen with after(:build), but just in case)
      unless instance.thumbnail_image.attached?
        # Save without validation first to get an ID for file attachments
        instance.save!(validate: false)

        # Attach thumbnail
        instance.thumbnail_image.attach(
          io: StringIO.new("\x89PNG\r\n\x1A\n"),
          filename: 'test_thumbnail.png',
          content_type: 'image/png'
        )
      end

      # Save with validation to ensure everything is correct
      instance.save!
    end

    # Factory variations
    trait :draft do
      status { 'draft' }
    end

    trait :educaplay do
      title { 'Prophet Names Quiz' }
      game_url { 'https://www.educaplay.com/game/22826787-learning_resource.html' }
      source_attribution { 'Educaplay' }
    end

    trait :without_thumbnail do
      after(:build, :skip_thumbnail_attachment) do |game|
        game.thumbnail_image.purge if game.thumbnail_image.attached?
        game.instance_variable_set(:@skip_thumbnail, true)
      end

      to_create(&:save!)
    end
  end
end
