# test that only admins can complete CRUD operations on stories.
require 'rails_helper'

RSpec.describe Admin::StoriesController, type: :controller do
  let(:admin_user) { FactoryBot.create(:user, :admin) }
  let(:regular_user) { FactoryBot.create(:user) }

  it 'requires admin authentication' do
    get :index
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'allows admin to view stories' do
    sign_in admin_user
    get :index
    expect(response).to be_successful
  end

  it 'allows admin to view a story' do
    sign_in admin_user
    story = FactoryBot.create(:story)
    get :show, params: { id: story.id }
    expect(response).to be_successful
  end

  it 'allows admin to create a story' do
    sign_in admin_user
    post :create, params: { story: { title: 'Test Story', content: 'Test Content', status: 'draft' } }
    expect(response).to redirect_to(admin_story_path(Story.last))
  end

  it 'allows admin to edit a story' do
    sign_in admin_user
    story = FactoryBot.create(:story)
    put :update,
        params: { id: story.id, story: { title: 'Updated Story', content: 'Updated Content', status: 'published' } }
    expect(response).to redirect_to(admin_story_path(Story.last))
  end

  it 'allows admin to delete a story' do
    sign_in admin_user
    story = FactoryBot.create(:story)
    delete :destroy, params: { id: story.id }
    expect(response).to redirect_to(admin_stories_path)
  end

  it 'does not allow non-admin users to complete CRUD operations' do
    sign_in regular_user
    get :index
    expect(response).to redirect_to(root_path)
  end

  it 'does not allow non-admin users to view a story' do
    sign_in regular_user
    story = FactoryBot.create(:story)
    get :show, params: { id: story.id }
    expect(response).to redirect_to(root_path)
  end
end
