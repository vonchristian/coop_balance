require 'rails_helper'
include ChosenSelect
describe 'New entry' do
  before(:each) do
    bookkeeper     = create(:bookkeeper, first_name: 'Test', last_name: 'Employee')
    @debit_account  = create(:asset, name: 'Debit account')
    @credit_account = create(:revenue, name: 'Credit account')
    bookkeeper.office.accounts << @debit_account
    bookkeeper.office.accounts << @credit_account

    login_as(bookkeeper, scope: :user)

    visit accounting_module_entries_path
    click_link 'New Entry'
  end

  it 'with valid attributes', js: true do
    fill_in 'account-search-form', with: 'Debit account', match: :first
    click_button 'search-btn'
    click_link "#{@debit_account.id}-select-account"
    fill_in 'Amount', with: 500
    select_from_chosen 'Debit', from: 'Type'
    
    click_button 'Add'

    click_link 'Remove Amount'

    expect(page).to have_content('removed successfully')

  end
end
