require 'rails_helper'

RSpec.describe 'Static', type: :request do
  describe 'GET /about' do
    it 'returns http success' do
      get '/about'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /contact' do
    it 'returns http success' do
      get '/contact'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /contribute' do
    it 'returns http success' do
      get '/contribute'
      expect(response).to have_http_status(:success)
    end
  end
end
