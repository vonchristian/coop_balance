require 'rails_helper'

describe 'New savings account withdrawal' do
  before do
    cash_on_hand_account = create(:asset, name: 'Cash on Hand (Teller)')
    user                 = create(:user, role: 'teller')
    @savings_account = create(:saving, office: user.office)
    user.cash_accounts << cash_on_hand_account
    deposit = build(:entry)
    deposit.credit_amounts.build(amount: 100_000, account: @savings_account.liability_account)
    deposit.debit_amounts.build(amount: 100_000, account: cash_on_hand_account)
    deposit.save!
    login_as(user, scope: :user)

    visit savings_account_path(@savings_account)
    click_link 'Withdraw'
  end

  it 'with valid attributes' do
    fill_in 'Amount',           with: 10_000
    fill_in 'Reference Number', with: '909045'
    fill_in 'Date',             with: Time.zone.today

    click_button 'Proceed'

    expect(page).to have_content('created successfully')
    click_link 'Confirm Transaction'

    expect(@savings_account.balance).to be 90_000
  end

  it 'with invalid attributes' do
    click_button 'Proceed'

    expect(page).to have_content("can't be blank")
  end
end
