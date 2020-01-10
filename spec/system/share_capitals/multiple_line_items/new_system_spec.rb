require 'rails_helper'

include ChosenSelect 
describe 'Multiple share capital build up transaction' do 
  it 'with valid attributes', js: true do 
    teller = create(:teller)
    cash  = create(:asset, name: 'Cash on Hand')
    teller.cash_accounts << cash
    office = teller.office
    share_capital = create(:share_capital, office: office)
    share_capital_2 = create(:share_capital, office: office)
    login_as(teller, scope: :user)

    visit share_capitals_path 
    click_link 'New Multiple Transaction'
    
    click_link "#{share_capital.id}-select-account"
    fill_in 'Amount', with: 500 

    click_button 'Add Amount'

    click_link "#{share_capital_2.id}-select-account"
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
