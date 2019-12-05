require 'rails_helper'
include ChosenSelect
describe 'New level one account category' do
  before(:each) do
    accountant = create(:accountant)
    login_as(accountant, scope: :user)
    visit accounting_module_level_one_account_categories_path
    click_link 'New Category'
  end

  it 'with valid attributes', js: true do
    fill_in 'Title', with: 'Cash in Bank'
    fill_in 'Code', with: '23123'
    check 'Contra'
    select_from_chosen 'Asset', from: 'Type'

    click_button 'Create Category'

    expect(page).to have_content('created successfully')
  end

  it 'with invalid attributes' do
    click_button 'Create Category'

    expect(page).to have_content("can't be blank")
  end
end
