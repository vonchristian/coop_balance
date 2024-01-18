require 'rails_helper'
include ChosenSelect

describe 'New time deposit transfer to savings' do
  before do
    member        = create(:member)
    teller        = create(:teller)
    cash          = create(:asset, name: 'Cash')
    teller.cash_accounts << cash
    @time_deposit = create(:time_deposit, office: teller.office, depositor: member)
    deposit       = build(:entry)
    deposit.credit_amounts.build(account: @time_deposit.liability_account, amount: 100_000)
    deposit.debit_amounts.build(account: cash, amount: 100_000)
    deposit.save!

    @saving = create(:saving, office: teller.office, depositor: member)

    login_as(teller, scope: :user)
    visit time_deposit_path(@time_deposit)
    click_link "#{@time_deposit.id}-accounting"
    click_link 'Transfer to Savings'
  end

  it 'with valid attributes', :js do
    click_link "#{@saving.id}-select-account"
    fill_in 'Reference number', with: 'test'
    fill_in 'Description',      with: 'Transfer to savings'
    fill_in 'Date',             with: Date.current.strftime('%B %e, %Y')

    click_button 'Proceed'
    page.execute_script 'window.scrollBy(0,10000)'

    click_link 'Confirm Transaction'

    expect(page).to have_content('confirmed successfully')
  end
end