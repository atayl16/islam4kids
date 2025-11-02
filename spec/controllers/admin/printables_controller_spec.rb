require 'rails_helper'

RSpec.describe Admin::PrintablesController, type: :controller do
  let(:admin_user) { FactoryBot.create(:user, :admin) }
  let(:regular_user) { FactoryBot.create(:user) }

  describe 'authentication and authorization' do
    it 'requires authentication' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'allows admin to view printables' do
      sign_in admin_user
      get :index
      expect(response).to be_successful
    end

    it 'does not allow non-admin users to view printables' do
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

    it 'assigns all printables to @printables' do
      sign_in admin_user
      printable1 = FactoryBot.create(:printable)
      printable2 = FactoryBot.create(:printable)
      get :index
      expect(assigns(:printables)).to include(printable1, printable2)
    end

    it 'orders printables by created_at descending' do
      sign_in admin_user
      old_printable = FactoryBot.create(:printable, created_at: 2.days.ago)
      new_printable = FactoryBot.create(:printable, created_at: 1.day.ago)
      get :index
      printables = assigns(:printables)
      expect(printables.first).to eq(new_printable)
      expect(printables.last).to eq(old_printable)
    end
  end

  describe 'GET #show' do
    it 'returns successful response for admin' do
      sign_in admin_user
      printable = FactoryBot.create(:printable)
      get :show, params: { id: printable.id }
      expect(response).to be_successful
    end

    it 'assigns the printable' do
      sign_in admin_user
      printable = FactoryBot.create(:printable)
      get :show, params: { id: printable.id }
      expect(assigns(:printable)).to eq(printable)
    end

    it 'does not allow non-admin users to view printable' do
      sign_in regular_user
      printable = FactoryBot.create(:printable)
      get :show, params: { id: printable.id }
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #new' do
    it 'returns successful response for admin' do
      sign_in admin_user
      get :new
      expect(response).to be_successful
    end

    it 'builds a new printable' do
      sign_in admin_user
      get :new
      expect(assigns(:printable)).to be_a_new(Printable)
    end
  end

  describe 'GET #edit' do
    it 'returns successful response for admin' do
      sign_in admin_user
      printable = FactoryBot.create(:printable)
      get :edit, params: { id: printable.id }
      expect(response).to be_successful
    end

    it 'assigns the printable' do
      sign_in admin_user
      printable = FactoryBot.create(:printable)
      get :edit, params: { id: printable.id }
      expect(assigns(:printable)).to eq(printable)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_params) do
        {
          title: 'Test Printable',
          description: 'Test Description',
          printable_type: 'worksheet',
          status: 'published'
        }
      end

      it 'creates a new printable' do
        sign_in admin_user
        expect do
          post :create, params: { printable: valid_params }
        end.to change(Printable, :count).by(1)
      end

      it 'redirects to the created printable' do
        sign_in admin_user
        post :create, params: { printable: valid_params }
        expect(response).to redirect_to(admin_printable_path(Printable.last))
      end

      it 'sets success flash notice' do
        sign_in admin_user
        post :create, params: { printable: valid_params }
        expect(flash[:notice]).to eq('Printable was successfully created.')
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          title: '',
          status: ''
        }
      end

      it 'does not create a new printable' do
        sign_in admin_user
        expect do
          post :create, params: { printable: invalid_params }
        end.not_to change(Printable, :count)
      end

      it 'renders the new template' do
        sign_in admin_user
        post :create, params: { printable: invalid_params }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PUT #update' do
    let(:printable) { FactoryBot.create(:printable) }

    context 'with valid params' do
      let(:update_params) do
        {
          title: 'Updated Printable Title',
          status: 'draft'
        }
      end

      it 'updates the printable' do
        sign_in admin_user
        put :update, params: { id: printable.id, printable: update_params }
        printable.reload
        expect(printable.title).to eq('Updated Printable Title')
        expect(printable.status).to eq('draft')
      end

      it 'redirects to the printable' do
        sign_in admin_user
        put :update, params: { id: printable.id, printable: update_params }
        expect(response).to redirect_to(admin_printable_path(printable))
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        {
          title: ''
        }
      end

      it 'does not update the printable' do
        sign_in admin_user
        original_title = printable.title
        put :update, params: { id: printable.id, printable: invalid_params }
        printable.reload
        expect(printable.title).to eq(original_title)
      end

      it 'renders the edit template' do
        sign_in admin_user
        put :update, params: { id: printable.id, printable: invalid_params }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the printable' do
      sign_in admin_user
      printable = FactoryBot.create(:printable)
      expect do
        delete :destroy, params: { id: printable.id }
      end.to change(Printable, :count).by(-1)
    end

    it 'redirects to printables index' do
      sign_in admin_user
      printable = FactoryBot.create(:printable)
      delete :destroy, params: { id: printable.id }
      expect(response).to redirect_to(admin_printables_path)
    end

    it 'sets success flash notice' do
      sign_in admin_user
      printable = FactoryBot.create(:printable)
      delete :destroy, params: { id: printable.id }
      expect(flash[:notice]).to eq('Printable was successfully deleted.')
    end
  end
end
