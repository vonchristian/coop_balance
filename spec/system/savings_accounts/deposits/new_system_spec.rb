require 'rails_helper'

describe 'New savings account deposit' do
  before do
    cash_on_hand_account = create(:asset, name: 'Cash on Hand (Teller)')
    user = create(:user, role: 'teller')
    user.cash_accounts << cash_on_hand_account
    login_as(user, scope: :user)
    savings_account = create(:saving, office: user.office)
    deposit = build(:entry)
    deposit.debit_amounts.build(amount: 100, account: cash_on_hand_account)
    deposit.credit_amounts.build(amount: 100, account: savings_account.liability_account)
    deposit.save!
    visit savings_account_path(savings_account)
    click_link 'Deposit'
  end

  it 'with valid attributes', :js do
    fill_in 'Amount',    with: 100_000
    fill_in 'Date',      with: Time.zone.today
    fill_in 'Reference Number', with: '909045'
    fill_in 'Date', with: Time.zone.today

    click_button 'Proceed'

    expect(page).to have_content('created successfully')

    click_link 'Confirm Transaction'
  end

  it 'with invalid attributes' do
    click_button 'Proceed'

    expect(page).to have_content("can't be blank")
  end
end
