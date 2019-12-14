require 'rails_helper'
include ChosenSelect
describe 'New share capital withdraw' do
  before(:each) do
    teller = create(:teller)
    cash = create(:asset, name: 'Cash')
    teller.cash_accounts << cash
    @share_capital = create(:share_capital, office: teller.office)

    capital_build_up = build(:entry)
    capital_build_up.debit_amounts.build(amount: 10_000, account: cash)
    capital_build_up.credit_amounts.build(amount: 10_000, account: @share_capital.share_capital_equity_account)
    capital_build_up.save!

    login_as(teller, scope: :user)

    visit share_capital_path(@share_capital)
    click_link "#{@share_capital.id}-settings"
    click_link 'Withdraw Capital'

  end

  it 'with valid attributes', js: true do
    fill_in 'Date', with: Date.current
    fill_in 'Reference number', with: 'test description'
    fill_in 'Description', with: 'test'
    select_from_chosen 'Cash', from: 'Cash account'
    click_button 'Proceed'

    expect(page).to have_content('created successfully')
    click_link 'Confirm Transaction'

    expect(page).to have_content('confirmed successfully')

    puts @share_capital.balance
  end

  end
