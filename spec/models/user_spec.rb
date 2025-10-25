# Users are mostly handled by Devise, so we don't need to test them too much.
# We did add is_admin to the User model, so we should test that.
require 'rails_helper'

RSpec.describe User, type: :model do
  it 'handles is_admin correctly when true' do
    user = described_class.new(email: 'test@example.com', password: 'password123', is_admin: true)
    expect(user.is_admin).to be_truthy
  end

  it 'handles is_admin correctly when false' do
    user = described_class.new(email: 'test@example.com', password: 'password123', is_admin: false)
    expect(user.is_admin).to be_falsey
  end
end
