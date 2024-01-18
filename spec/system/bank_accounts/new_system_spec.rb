require 'rails_helper'
include ChosenSelect

describe 'Create bank account' do
  before do
    user = create(:treasurer)
    cash_account = create(:asset, name: 'Cash in Bank')
    revenue = create(:revenue, name: 'Interest Income fron Deposits')
    user.office.accounts << cash_account
    user.office.accounts << revenue
    user.cash_accounts << cash_account
    login_as(user, scope: :user)
    visit bank_accounts_path
    click_link 'New Bank Account'
  end

  it 'with valid attributes', :js do
    fill_in 'Bank name', with: 'Land Bank'
    fill_in 'Bank address', with: 'Lagawe, Ifugao'
    fill_in 'Account number', with: '4322342342'
    select_from_chosen 'Cash in Bank', from: 'Cash account'
    select_from_chosen 'Interest Income fron Deposits', from: 'Interest revenue account'
    click_button 'Proceed'
  end
end
