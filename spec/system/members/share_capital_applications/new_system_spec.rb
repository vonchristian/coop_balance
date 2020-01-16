require 'rails_helper'

include ChosenSelect

describe 'New share capital application' do
  before(:each) do
    teller                = create(:teller)
    cash                  = create(:asset, name: 'Cash')
    office                = teller.office 
    cooperative           = teller.cooperative
    member                = create(:member) { include Addressing }
    membership            = create(:membership, cooperator: member, cooperative: cooperative)
    share_capital_product = create(:share_capital_product, cooperative: cooperative, name: 'Share Capital - Common')
    create(:office_share_capital_product, office: office, share_capital_product: share_capital_product)
    teller.cash_accounts << cash 
    
    login_as(teller, scope: :user)
    visit members_path
    click_link member.full_name
    click_link "#{member.id}-share-capitals"
    click_link 'New Share Capital'
  end

  it 'with valid attributes', js: true do
    select_from_chosen 'Share Capital - Common', from: 'Share capital product'
    fill_in 'Date opened', with: Date.current.strftime('%B %e, %Y')
    fill_in 'Amount', with: 5_000
    fill_in 'Reference number', with: '10101'
    fill_in 'Beneficiary/ies', with: 'test beneficiary'
    page.execute_script "window.scrollBy(0,10000)"
    
    select_from_chosen 'Cash', from: 'Cash account'
    
    click_button 'Proceed'

    expect(page).to have_content('created successfully')
    
    click_link 'Confirm Transaction'
    page.execute_script "window.scrollBy(0,10000)"
  end

  it 'with invalid attributes' do 
    click_button 'Proceed'

    expect(page).to have_content("can't be blank")
  end 
end
