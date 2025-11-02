require 'rails_helper'

RSpec.describe Printable, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      printable = build(:printable)
      expect(printable).to be_valid
    end

    it 'is not valid without a title' do
      printable = build(:printable, title: nil)
      expect(printable).not_to be_valid
    end

    it 'is valid without a printable_type (optional)' do
      printable = described_class.new(title: 'Test Printable', status: 'published')
      expect(printable).to be_valid
    end

    it 'is valid without a pdf_file (optional)' do
      printable = described_class.new(
        title: 'Test Printable',
        printable_type: :worksheet,
        status: 'published'
      )
      expect(printable).to be_valid
    end

    it 'is valid without a thumbnail_image (optional)' do
      printable = described_class.new(
        title: 'Test Printable',
        printable_type: :worksheet,
        status: 'published'
      )
      expect(printable).to be_valid
    end
  end

  describe 'enum' do
    it 'accepts valid printable types' do
      expect { build(:printable, printable_type: :ebook) }.not_to raise_error
      expect { build(:printable, printable_type: :worksheet) }.not_to raise_error
      expect { build(:printable, printable_type: :activity) }.not_to raise_error
      expect { build(:printable, printable_type: :journal) }.not_to raise_error
    end

    it 'raises error with invalid printable type' do
      expect do
        described_class.create!(title: 'Test', printable_type: 'invalid_type')
      end.to raise_error(ArgumentError)
    end
  end

  describe 'Publishable concern' do
    it 'includes published scope' do
      published_printable = create(:printable, status: 'published')
      draft_printable = create(:printable, :draft)

      expect(described_class.published).to include(published_printable)
      expect(described_class.published).not_to include(draft_printable)
    end

    it 'has published? method' do
      published_printable = build(:printable, status: 'published')
      draft_printable = build(:printable, status: 'draft')

      expect(published_printable.published?).to be true
      expect(draft_printable.published?).to be false
    end
  end

  describe 'ActiveStorage attachments' do
    it 'has pdf_file attached' do
      printable = create(:printable)
      expect(printable.pdf_file).to be_attached
    end

    it 'has thumbnail_image attached' do
      printable = create(:printable)
      expect(printable.thumbnail_image).to be_attached
    end

    it 'can have image_file attached instead of pdf_file' do
      printable = build(:printable)
      printable.pdf_file.purge if printable.pdf_file.attached?
      printable.image_file.attach(
        io: StringIO.new("\x89PNG\r\n\x1A\n"),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
      printable.save!
      expect(printable.image_file).to be_attached
      expect(printable.pdf_file).not_to be_attached
    end
  end

  describe 'helper methods' do
    it 'main_file returns pdf_file when attached' do
      printable = create(:printable)
      expect(printable.main_file).to eq(printable.pdf_file)
    end

    it 'main_file returns image_file when pdf_file not attached' do
      printable = build(:printable)
      printable.pdf_file.purge if printable.pdf_file.attached?
      printable.image_file.attach(
        io: StringIO.new("\x89PNG\r\n\x1A\n"),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
      printable.save!
      expect(printable.main_file).to eq(printable.image_file)
    end

    it 'has_main_file? returns true when pdf_file attached' do
      printable = create(:printable)
      expect(printable.has_main_file?).to be true
    end

    it 'has_main_file? returns true when image_file attached' do
      printable = build(:printable)
      printable.pdf_file.purge if printable.pdf_file.attached?
      printable.image_file.attach(
        io: StringIO.new("\x89PNG\r\n\x1A\n"),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
      printable.save!
      expect(printable.has_main_file?).to be true
    end

    it 'display_thumbnail returns thumbnail_image when attached' do
      printable = create(:printable)
      expect(printable.display_thumbnail).to eq(printable.thumbnail_image)
    end

    it 'display_thumbnail falls back to image_file when no thumbnail' do
      printable = build(:printable)
      printable.thumbnail_image.purge if printable.thumbnail_image.attached?
      printable.image_file.attach(
        io: StringIO.new("\x89PNG\r\n\x1A\n"),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
      printable.save!
      expect(printable.display_thumbnail).to eq(printable.image_file)
    end

    it 'using_same_image_for_thumbnail? returns true when image_file used as thumbnail' do
      printable = build(:printable)
      printable.thumbnail_image.purge if printable.thumbnail_image.attached?
      printable.image_file.attach(
        io: StringIO.new("\x89PNG\r\n\x1A\n"),
        filename: 'test_image.png',
        content_type: 'image/png'
      )
      printable.save!
      expect(printable.using_same_image_for_thumbnail?).to be true
    end
  end

  describe 'factory traits' do
    it 'creates ebook printable with trait' do
      printable = create(:printable, :ebook)
      expect(printable.printable_type).to eq('ebook')
      expect(printable.title).to include('Prophets')
    end

    it 'creates journal printable with trait' do
      printable = create(:printable, :journal)
      expect(printable.printable_type).to eq('journal')
      expect(printable.title).to include('Journal')
    end

    it 'creates draft printable with trait' do
      printable = create(:printable, :draft)
      expect(printable.status).to eq('draft')
    end
  end
end
