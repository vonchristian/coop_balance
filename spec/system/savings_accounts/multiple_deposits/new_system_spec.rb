require 'rails_helper'

include ChosenSelect 
describe 'Multiple share capital build up transaction' do 
  it 'with valid attributes', js: true do 
    teller    = create(:teller)
    cash      = create(:asset, name: 'Cash on Hand')
    teller.cash_accounts << cash
    office    = teller.office
    saving   = create(:saving, office: office)
    saving_2 = create(:saving, office: office)
    login_as(teller, scope: :user)

    visit savings_accounts_path 
    click_link 'New Deposits'
    
    click_link "#{saving.id}-select-account"
    fill_in 'Amount', with: 500 

    click_button 'Add Amount'

    click_link "#{saving_2.id}-select-account"
    fill_in 'Amount', with: 500 

    click_button 'Add Amount'


    fill_in 'Date', with: Date.current 
    fill_in 'Description', with: 'share capital build ups'
    fill_in 'Reference number', with: '10064'
    select_from_chosen 'Cash on Hand', from: 'Cash account'
    click_button 'Proceed'

    click_link 'Confirm Transaction'

    expect(page).to have_content('confirmed successfully')
  end 
end 
