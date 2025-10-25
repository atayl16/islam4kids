require 'rails_helper'

RSpec.describe Admin::BaseController, type: :controller do
  # Admin::BaseController is abstract, so test through a concrete child controller
  # We'll test the authorization through Admin::BlogsController instead
  it 'exists' do
    expect(Admin::BaseController).to be
  end
end
