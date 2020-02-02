require 'rails_helper'

describe 'New share capital balance transfer' do 
  before(:each) do 
    bookkeeper     = create(:bookkeeper)
    cash           = create(:asset)
    bookkeeper.cash_accounts << cash
    @share_capital = create(:share_capital, office: bookkeeper.office)

    capital_build_up_1 = build(:entry)
    capital_build_up_1.debit_amounts.build(amount: 10_000, account: cash)
    capital_build_up_1.credit_amounts.build(amount: 10_000, account: @share_capital.share_capital_equity_account)
    capital_build_up_1.save!

    @share_capital_2   = create(:share_capital, office: bookkeeper.office)
    capital_build_up_2 = build(:entry)

    capital_build_up_2.debit_amounts.build(amount: 10_000, account: cash)
    capital_build_up_2.credit_amounts.build(amount: 10_000, account: @share_capital_2.share_capital_equity_account)
    capital_build_up_2.save!

    login_as(bookkeeper, scope: :user)
    visit share_capital_path(@share_capital)
    click_link "#{@share_capital.id}-accounting"
    click_link 'New Balance Transfer'
  end
  it 'with valid attributes', js: true do 
    fill_in 'share-capital-search-form', with: 'Juan'

    click_link "#{@share_capital_2.id}-select-destination-account"

    fill_in 'Amount', with: 1000 
    
    click_button 'Proceed'

    fill_in 'Date', with: Date.current 
    fill_in 'Reference number', with: '13123'
    fill_in 'Description', with: 'share capital transfer balance'
    click_button 'Proceed'

    click_link 'Confirm Transaction'

    expect(page).to have_content('confirmed successfully')
    expect(@share_capital.balance).to eql 9_000
    expect(@share_capital_2.balance).to eql 11_000 

  end
  
end