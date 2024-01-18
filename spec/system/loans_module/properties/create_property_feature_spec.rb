require 'rails_helper'

describe 'Create Property' do
  before do
    user = create(:user, role: 'loan_officer')
    login_as(user, scope: :user)
    member = create(:member)
    visit loans_module_member_path(member)
    click_link 'New Property'
  end

  it 'with valid attributes' do
  end
end