require 'rails_helper'

RSpec.describe StoriesController, type: :controller do
  it 'allows non-admin users to view stories' do
    FactoryBot.create(:story, status: 'published')
    get :index
    expect(response).to be_successful
  end

  it 'allows non-admin users to view a story' do
    story = FactoryBot.create(:story, status: 'published')
    get :show, params: { id: story.id }
    expect(response).to be_successful
  end
end
