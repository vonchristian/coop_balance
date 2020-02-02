require 'rails_helper'

describe 'New balance transfer' do
  before(:each) do
    bookkeeper = create(:bookkeeper)
    teller     = create(:teller)
    cash       = create(:asset)
    office     = bookkeeper.office
    @saving_1  = create(:saving, office: office)
    @saving_2  = create(:saving, office: office)

    deposit_1  = build(:entry)
    deposit_1.debit_amounts.build(amount: 1000, account: cash)
    deposit_1.credit_amounts.build(amount: 1000, account: @saving_1.liability_account)
    deposit_1.save!


    deposit_2  = build(:entry)
    deposit_2.debit_amounts.build(amount: 1000, account: cash)
    deposit_2.credit_amounts.build(amount: 1000, account: @saving_2.liability_account)
    deposit_2.save!
    teller.cash_accounts << cash

    login_as(bookkeeper, scope: :user)

    visit savings_account_path(@saving_1)
    click_link "#{@saving_1.id}-accounting"
    click_link 'Balance Transfer'
    click_link "#{@saving_2.id}-select-destination-account"
  end

  it 'with valid attributes', js: true do
    fill_in 'Amount', with: 100
  end

  it 'with invalid' do
  end
end
