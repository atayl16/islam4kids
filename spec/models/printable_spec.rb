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

    it 'is not valid without a printable_type' do
      printable = described_class.new(title: 'Test Printable')
      expect(printable).not_to be_valid
    end

    it 'is not valid without a pdf_file' do
      printable = described_class.new(title: 'Test Printable', printable_type: :worksheet)
      expect(printable).not_to be_valid
    end

    it 'is not valid without a thumbnail_image' do # rubocop:disable RSpec/ExampleLength
      printable = described_class.new(title: 'Test Printable', printable_type: :worksheet)
      printable.pdf_file.attach(
        io: StringIO.new('%PDF-1.4 test'),
        filename: 'test.pdf',
        content_type: 'application/pdf'
      )
      expect(printable).not_to be_valid
    end
  end

  describe 'enum' do
    it 'accepts valid printable types' do # rubocop:disable RSpec/MultipleExpectations
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
    it 'includes published scope' do # rubocop:disable RSpec/MultipleExpectations
      published_printable = create(:printable, status: 'published')
      draft_printable = create(:printable, :draft)

      expect(described_class.published).to include(published_printable)
      expect(described_class.published).not_to include(draft_printable)
    end

    it 'has published? method' do # rubocop:disable RSpec/MultipleExpectations
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
  end

  describe 'factory traits' do
    it 'creates ebook printable with trait' do # rubocop:disable RSpec/MultipleExpectations
      printable = create(:printable, :ebook)
      expect(printable.printable_type).to eq('ebook')
      expect(printable.title).to include('Prophets')
    end

    it 'creates journal printable with trait' do # rubocop:disable RSpec/MultipleExpectations
      printable = create(:printable, :journal)
      expect(printable.printable_type).to eq('journal')
      expect(printable.title).to include('Journal')
    end

    it 'creates draft printable with trait' do # rubocop:disable RSpec/MultipleExpectations
      printable = create(:printable, :draft)
      expect(printable.status).to eq('draft')
      expect(printable.published_at).to be_nil
    end
  end
end
