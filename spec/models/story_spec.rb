require 'rails_helper'

RSpec.describe Story, type: :model do
  it 'is valid with valid attributes' do
    expect(described_class.new(title: 'Test Story', content: 'Test Content', status: 'draft')).to be_valid
  end

  it 'is not valid without a title' do
    expect(described_class.new(content: 'Test Content', status: 'draft')).not_to be_valid
  end

  it 'is not valid without content' do
    expect(described_class.new(title: 'Test Story', status: 'draft')).not_to be_valid
  end

  it 'is not valid without a status' do
    expect(described_class.new(title: 'Test Story', content: 'Test Content')).not_to be_valid
  end

  it 'raises ArgumentError with an invalid status' do
    expect do
      described_class.create!(title: 'Test Story', content: 'Test Content', status: 'invalid')
    end.to raise_error(ArgumentError)
  end

  it 'is valid with a status of published' do
    expect(described_class.new(title: 'Test Story', content: 'Test Content', status: 'published')).to be_valid
  end

  it 'is valid with a status of archived' do
    expect(described_class.new(title: 'Test Story', content: 'Test Content', status: 'archived')).to be_valid
  end
end
