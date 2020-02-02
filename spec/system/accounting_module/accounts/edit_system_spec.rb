require 'rails_helper'
include ChosenSelect
describe 'Edit account' do
  before(:each) do
    bookkeeper  = create(:bookkeeper)
    cooperative = bookkeeper.cooperative
    account     = create(:asset)
    bookkeeper.office.accounts << account
    l1_category = create(:asset_level_one_account_category, title: 'Test Category', office: bookkeeper.office)
    cooperative.accounts << account
    login_as(bookkeeper, scope: :user)
    visit accounting_module_account_path(account)
    click_link "#{account.id}-settings"
    click_link 'Edit Account'
  end

  it 'with valid attributes', js: true do
    fill_in 'Name', with: 'test account'
    fill_in 'Code', with: 'test code'
    select 'Asset'
    select_from_chosen 'Test Category', from: 'L1 Account Category'
    check 'Contra'

    click_button 'Update Account'

    expect(page).to have_content 'updated successfully'
  end

  it 'with invalid attributes' do
    fill_in 'Name', with: ''
    fill_in 'Code', with: ''

    click_button 'Update Account'

    expect(page).to have_content("can't be blank")
  end

end
