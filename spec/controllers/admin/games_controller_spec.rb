require 'rails_helper'

RSpec.describe Admin::GamesController, type: :controller do
  let(:admin_user) { FactoryBot.create(:user, :admin) }
  let(:regular_user) { FactoryBot.create(:user) }

  describe 'authentication and authorization' do
    it 'requires authentication' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'allows admin to view games' do
      sign_in admin_user
      get :index
      expect(response).to be_successful
    end

    it 'does not allow non-admin users to view games' do
      sign_in regular_user
      get :index
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #index' do
    it 'returns successful response for admin' do
      sign_in admin_user
      get :index
      expect(response).to be_successful
    end

    it 'assigns all games to @games' do
      sign_in admin_user
      game1 = FactoryBot.create(:game)
      game2 = FactoryBot.create(:game)
      get :index
      expect(assigns(:games)).to include(game1, game2)
    end
  end

  describe 'GET #show' do
    it 'returns successful response for admin' do
      sign_in admin_user
      game = FactoryBot.create(:game)
      get :show, params: { id: game.id }
      expect(response).to be_successful
    end

    it 'does not allow non-admin users to view game' do
      sign_in regular_user
      game = FactoryBot.create(:game)
      get :show, params: { id: game.id }
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #new' do
    it 'returns successful response for admin' do
      sign_in admin_user
      get :new
      expect(response).to be_successful
    end

    it 'builds a new game' do
      sign_in admin_user
      get :new
      expect(assigns(:game)).to be_a_new(Game)
    end
  end

  describe 'GET #edit' do
    it 'returns successful response for admin' do
      sign_in admin_user
      game = FactoryBot.create(:game)
      get :edit, params: { id: game.id }
      expect(response).to be_successful
    end

    it 'assigns the game' do
      sign_in admin_user
      game = FactoryBot.create(:game)
      get :edit, params: { id: game.id }
      expect(assigns(:game)).to eq(game)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_params) do
        {
          title: 'Test Game',
          description: 'Test Description',
          game_url: 'https://wordwall.net/resource/123/test',
          source_attribution: 'Wordwall',
          status: 'published'
        }
      end

      it 'creates a new game' do
        sign_in admin_user
        expect do
          post :create, params: { game: valid_params }
        end.to change(Game, :count).by(1)
      end

      it 'redirects to the created game' do
        sign_in admin_user
        post :create, params: { game: valid_params }
        expect(response).to redirect_to(admin_game_path(Game.last))
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          title: '',
          game_url: 'invalid-url'
        }
      end

      it 'does not create a new game' do
        sign_in admin_user
        expect do
          post :create, params: { game: invalid_params }
        end.not_to change(Game, :count)
      end

      it 'renders the new template' do
        sign_in admin_user
        post :create, params: { game: invalid_params }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    let(:game) { FactoryBot.create(:game) }

    context 'with valid params' do
      let(:update_params) do
        {
          title: 'Updated Game Title',
          status: 'draft'
        }
      end

      it 'updates the game' do
        sign_in admin_user
        put :update, params: { id: game.id, game: update_params }
        game.reload
        expect(game.title).to eq('Updated Game Title')
        expect(game.status).to eq('draft')
      end

      it 'redirects to the game' do
        sign_in admin_user
        put :update, params: { id: game.id, game: update_params }
        expect(response).to redirect_to(admin_game_path(game))
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          title: '',
          game_url: ''
        }
      end

      it 'does not update the game' do
        sign_in admin_user
        original_title = game.title
        put :update, params: { id: game.id, game: invalid_params }
        game.reload
        expect(game.title).to eq(original_title)
      end

      it 'renders the edit template' do
        sign_in admin_user
        put :update, params: { id: game.id, game: invalid_params }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the game' do
      sign_in admin_user
      game = FactoryBot.create(:game)
      expect do
        delete :destroy, params: { id: game.id }
      end.to change(Game, :count).by(-1)
    end

    it 'redirects to games index' do
      sign_in admin_user
      game = FactoryBot.create(:game)
      delete :destroy, params: { id: game.id }
      expect(response).to redirect_to(admin_games_path)
    end
  end
end
