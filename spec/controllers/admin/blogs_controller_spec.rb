# test that only admins can complete CRUD operations on blogs.
require 'rails_helper'

RSpec.describe Admin::BlogsController, type: :controller do
  let(:admin_user) { FactoryBot.create(:user, :admin) }
  let(:regular_user) { FactoryBot.create(:user) }

  it 'requires admin authentication' do
    get :index
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'allows admin to view blogs' do
    sign_in admin_user
    get :index
    expect(response).to be_successful
  end

  it 'allows admin to view a blog' do
    sign_in admin_user
    blog = FactoryBot.create(:blog)
    get :show, params: { id: blog.id }
    expect(response).to be_successful
  end

  it 'allows admin to create a blog' do
    sign_in admin_user
    post :create, params: { blog: { title: 'Test Blog', content: 'Test Content', status: 'draft' } }
    expect(response).to redirect_to(admin_blog_path(Blog.last))
  end

  it 'allows admin to edit a blog' do
    sign_in admin_user
    blog = FactoryBot.create(:blog)
    put :update,
        params: { id: blog.id, blog: { title: 'Updated Blog', content: 'Updated Content', status: 'published' } }
    expect(response).to redirect_to(admin_blog_path(Blog.last))
  end

  it 'allows admin to delete a blog' do
    sign_in admin_user
    blog = FactoryBot.create(:blog)
    delete :destroy, params: { id: blog.id }
    expect(response).to redirect_to(admin_blogs_path)
  end

  it 'does not allow non-admin users to complete CRUD operations' do
    sign_in regular_user
    get :index
    expect(response).to redirect_to(root_path)
  end

  it 'does not allow non-admin users to view a blog' do
    sign_in regular_user
    blog = FactoryBot.create(:blog)
    get :show, params: { id: blog.id }
    expect(response).to redirect_to(root_path)
  end
end
