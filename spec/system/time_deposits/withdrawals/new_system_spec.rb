require 'rails_helper'
include ChosenSelect
describe 'New time deposit withdraw' do
  before(:each) do
    teller = create(:teller)
    cash   = create(:asset, name: 'Cash')
    teller.cash_accounts << cash
    @time_deposit = create(:time_deposit, office: teller.office)
    deposit = build(:entry)
    deposit.credit_amounts.build(account: @time_deposit.liability_account, amount: 100_000)
    deposit.debit_amounts.build(account: cash, amount: 100_000)
    deposit.save!
    login_as(teller, scope: :user)
    visit time_deposit_path(@time_deposit)
    click_link 'Withdraw'
  end

  it 'with valid attributes', js: true do
    select_from_chosen 'Cash', from: 'Cash account'
    fill_in 'Date', with: Date.current
    fill_in 'Reference Number', with: 'test'

    click_button 'Proceed'


    expect(page).to have_content('created successfully')


    click_link 'Confirm Transaction'

    expect(page).to have_content('withdrawn successfully')
    puts @time_deposit.balance
  end
end
