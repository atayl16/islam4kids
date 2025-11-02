require 'rails_helper'

RSpec.describe 'Printables', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get printables_path
      expect(response).to have_http_status(:success)
    end

    it 'assigns published printables to @printables' do
      published_printable = FactoryBot.create(:printable, status: 'published')
      FactoryBot.create(:printable, status: 'draft')
      get printables_path
      expect(assigns(:printables)).to include(published_printable)
      expect(assigns(:printables).size).to eq(1)
    end

    it 'orders printables by created_at descending' do
      old_printable = FactoryBot.create(:printable, status: 'published', created_at: 2.days.ago)
      new_printable = FactoryBot.create(:printable, status: 'published', created_at: 1.day.ago)
      get printables_path
      printables = assigns(:printables)
      expect(printables.first).to eq(new_printable)
      expect(printables.last).to eq(old_printable)
    end

    it 'excludes draft printables' do
      FactoryBot.create(:printable, status: 'draft')
      get printables_path
      expect(assigns(:printables)).to be_empty
    end
  end

  describe 'GET /show' do
    it 'returns http success for published printable' do
      printable = create(:printable, status: 'published')
      get printable_path(printable)
      expect(response).to have_http_status(:success)
    end

    it 'assigns the published printable' do
      printable = create(:printable, status: 'published')
      get printable_path(printable)
      expect(assigns(:printable)).to eq(printable)
    end

    it 'redirects and shows alert for draft printable' do
      draft_printable = create(:printable, status: 'draft')
      get printable_path(draft_printable)
      expect(response).to redirect_to(printables_path)
      expect(flash[:alert]).to eq('Printable not found')
    end

    it 'redirects and shows alert for non-existent printable' do
      get printable_path(999_999_999)
      expect(response).to redirect_to(printables_path)
      expect(flash[:alert]).to eq('Printable not found')
    end
  end
end
