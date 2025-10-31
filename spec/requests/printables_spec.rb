require 'rails_helper'

RSpec.describe 'Printables', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get printables_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      printable = create(:printable, status: 'published')
      get printable_path(printable)
      expect(response).to have_http_status(:success)
    end
  end
end
