require 'rails_helper'

describe 'New savings account withdrawal' do
  before(:each) do
    cash_on_hand_account = create(:asset, name: "Cash on Hand (Teller)")
    user                 = create(:user, role: 'teller')
    user.cash_accounts << cash_on_hand_account
    savings_account = create(:saving, cooperative: user.cooperative)
    login_as(user, scope: :user )

    visit savings_account_url(savings_account)
    click_link "Deposit"
    fill_in "Amount", with: 100_000
    fill_in 'Reference Number', with: '909045'
    fill_in 'Date', with: Date.today

    click_button "Proceed"
    click_link "Confirm Transaction"
    click_link 'Withdraw'
  end
  it 'with valid attributes' do
    fill_in "Amount", with: 10_000
    fill_in 'Reference Number', with: '909045'
    fill_in 'Date', with: Date.today

    click_button "Proceed"

    expect(page).to have_content('created successfully')
    click_link 'Confirm Transaction'
  end

  it 'with invalid attributes' do
    click_button "Proceed"

    expect(page).to have_content("can't be blank")
  end
end
