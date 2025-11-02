require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      game = build(:game)
      expect(game).to be_valid
    end

    it 'is not valid without a title' do
      game = build(:game, title: nil)
      expect(game).not_to be_valid
    end

    it 'is not valid without a game_url' do
      game = build(:game, game_url: nil)
      expect(game).not_to be_valid
    end

    it 'is not valid without a status' do
      game = build(:game, status: nil)
      expect(game).not_to be_valid
    end

    it 'is valid without a description (optional)' do
      game = described_class.new(
        title: 'Test Game',
        game_url: 'https://wordwall.net/resource/123/test',
        status: 'published'
      )
      expect(game).to be_valid
    end

    it 'is valid without a source_attribution (optional)' do
      game = described_class.new(
        title: 'Test Game',
        game_url: 'https://wordwall.net/resource/123/test',
        status: 'published'
      )
      expect(game).to be_valid
    end

    it 'rejects invalid URL formats' do
      game = build(:game, game_url: 'not-a-url')
      expect(game).not_to be_valid
      expect(game.errors[:game_url]).to be_present
    end

    it 'accepts http URLs' do
      game = build(:game, game_url: 'http://example.com/game')
      expect(game).to be_valid
    end

    it 'accepts https URLs' do
      game = build(:game, game_url: 'https://example.com/game')
      expect(game).to be_valid
    end

    it 'rejects ftp URLs' do
      game = build(:game, game_url: 'ftp://example.com/game')
      expect(game).not_to be_valid
    end

    it 'rejects invalid thumbnail content types' do
      game = build(:game)
      game.thumbnail_image.purge if game.thumbnail_image.attached?
      game.thumbnail_image.attach(
        io: StringIO.new('not an image'),
        filename: 'test.pdf',
        content_type: 'application/pdf'
      )
      expect(game).not_to be_valid
      expect(game.errors[:thumbnail_image]).to be_present
    end

    it 'accepts valid thumbnail image types' do
      ['image/png', 'image/jpeg', 'image/gif', 'image/webp'].each do |content_type|
        game = build(:game)
        game.thumbnail_image.purge if game.thumbnail_image.attached?
        game.thumbnail_image.attach(
          io: StringIO.new("\x89PNG\r\n\x1A\n"),
          filename: 'test.png',
          content_type: content_type
        )
        game.valid?
        expect(game.errors[:thumbnail_image]).to be_empty, "Failed for #{content_type}"
      end
    end
  end

  describe 'Publishable concern' do
    it 'includes published scope' do
      published_game = create(:game, status: 'published')
      draft_game = create(:game, :draft)

      expect(described_class.published).to include(published_game)
      expect(described_class.published).not_to include(draft_game)
    end

    it 'has published? method' do
      published_game = build(:game, status: 'published')
      draft_game = build(:game, status: 'draft')

      expect(published_game.published?).to be true
      expect(draft_game.published?).to be false
    end

    it 'raises ArgumentError with an invalid status' do
      expect do
        described_class.create!(
          title: 'Test Game',
          game_url: 'https://wordwall.net/resource/123/test',
          status: 'invalid'
        )
      end.to raise_error(ArgumentError)
    end
  end

  describe 'ActiveStorage attachments' do
    it 'has thumbnail_image attached' do
      game = create(:game)
      expect(game.thumbnail_image).to be_attached
    end

    it 'can exist without a thumbnail_image' do
      game = create(:game, :without_thumbnail)
      expect(game.thumbnail_image).not_to be_attached
      expect(game).to be_valid
    end

    it 'validates thumbnail size is less than 10MB' do
      game = build(:game)
      game.thumbnail_image.purge if game.thumbnail_image.attached?
      # Create a file that's larger than 10MB
      large_content = StringIO.new('x' * (11.megabytes + 1))
      game.thumbnail_image.attach(
        io: large_content,
        filename: 'large_image.png',
        content_type: 'image/png'
      )
      expect(game).not_to be_valid
      expect(game.errors[:thumbnail_image]).to be_present
    end
  end

  describe 'factory traits' do
    it 'creates draft game with trait' do
      game = create(:game, :draft)
      expect(game.status).to eq('draft')
    end

    it 'creates educaplay game with trait' do
      game = create(:game, :educaplay)
      expect(game.title).to include('Prophet')
      expect(game.source_attribution).to eq('Educaplay')
      expect(game.game_url).to include('educaplay.com')
    end

    it 'creates game without thumbnail with trait' do
      game = create(:game, :without_thumbnail)
      expect(game.thumbnail_image).not_to be_attached
    end
  end
end
