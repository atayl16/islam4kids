require 'rails_helper'

RSpec.describe Public::BlogsController, type: :controller do
  it 'allows non-admin users to view blogs' do
    FactoryBot.create(:blog, status: 'published')
    get :index
    expect(response).to be_successful
  end

  it 'allows non-admin users to view a blog' do
    blog = FactoryBot.create(:blog, status: 'published')
    get :show, params: { id: blog.id }
    expect(response).to be_successful
  end
end
