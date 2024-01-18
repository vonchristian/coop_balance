require 'rails_helper'

describe 'Add Co maker to loan' do
  before do
    user = create(:user)
    login_as(user, scope: :user)
    loan = create(:loan)
    visit loans_module_loan_url(loan)
    click_link 'Add Co Maker'
  end

  it 'with valid attributes' do
    create(:member)
    click_button 'Add'

    expect(page).to have_content 'successfully'
  end
end