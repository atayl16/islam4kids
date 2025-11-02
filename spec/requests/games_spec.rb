require 'rails_helper'

RSpec.describe 'Games', type: :request do
  describe 'GET /games' do
    it 'returns http success' do
      get games_path
      expect(response).to have_http_status(:success)
    end

    it 'assigns published games to @games' do
      published_game = FactoryBot.create(:game, status: 'published')
      FactoryBot.create(:game, status: 'draft')
      get games_path
      expect(assigns(:games)).to include(published_game)
      expect(assigns(:games).size).to eq(1)
    end

    it 'orders games by created_at descending' do
      old_game = FactoryBot.create(:game, status: 'published', created_at: 2.days.ago)
      new_game = FactoryBot.create(:game, status: 'published', created_at: 1.day.ago)
      get games_path
      games = assigns(:games)
      expect(games.first).to eq(new_game)
      expect(games.last).to eq(old_game)
    end

    it 'excludes draft games' do
      FactoryBot.create(:game, status: 'draft')
      get games_path
      expect(assigns(:games)).to be_empty
    end
  end
end
