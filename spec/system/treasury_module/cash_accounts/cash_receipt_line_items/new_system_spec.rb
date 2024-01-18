require 'rails_helper'
include ChosenSelect
describe 'New cash receipt line item' do
  before do
    user         = create(:user, role: 'teller')
    cash_on_hand = create(:asset, name: 'Cash on Hand (Teller)')
    @revenue     = create(:revenue, name: 'Sales')
    @member = create(:member, first_name: 'Juan', last_name: 'Cruz')
    create(:membership, office: user.office, cooperative: user.cooperative, cooperator: @member)

    user.cash_accounts << cash_on_hand
    user.office.accounts << @revenue
    user.office.accounts << cash_on_hand
    login_as(user, scope: :user)
    visit treasury_module_cash_account_path(cash_on_hand)
    click_link 'Receive'
  end

  it 'with valid attributes', :js do
    fill_in 'cash-receipt-account-search-form', with: 'Sales'
    click_button 'search-btn'

    click_link "#{@revenue.id}-select-account"
    fill_in 'cash-receipt-amount', with: 100_000
    click_button 'Add Amount'

    expect(page).to have_content('Added successfully')

    fill_in 'payee-search-form', with: 'Juan'
    click_button 'payee-search-btn'
    click_link "#{@member.id}-select-payee"
    fill_in 'Date', with: Date.current
    fill_in 'Description', with: 'test'
    fill_in 'Reference number', with: 'test'
    click_button 'Proceed'
    page.execute_script 'window.scrollBy(0,10000)'

    click_link 'Confirm Transaction'
  end
end
