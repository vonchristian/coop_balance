require 'rails_helper'
include ChosenSelect

describe 'Create Account' do
  before do
    user = create(:user, role: 'accountant')
    login_as(user, scope: :user)
    visit accounting_module_accounts_path
    click_link 'New Account'
  end

  it 'with valid attributes', :js do
    select_from_chosen 'Level 1 Category', from: 'Level one account category'
    fill_in 'Name', with: 'Cash on Hand'
    fill_in 'Code', with: '00932'
    select 'AccountingModule::Asset'

    click_button 'Create Account'

    expect(page).to have_content('created successfully')
  end

  it 'with invalid attributes' do
    click_button 'Create Account'

    expect(page).to have_content("can't be blank")
  end
end
