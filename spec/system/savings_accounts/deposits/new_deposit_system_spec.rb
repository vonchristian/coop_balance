require 'rails_helper'

describe 'New savings account deposit' do
  before(:each) do
    cash_on_hand_account = create(:asset, name: "Cash on Hand (Teller)")
    user = create(:user, role: 'teller', cash_on_hand_account: cash_on_hand_account)
    login_as(user, scope: :user )
    savings_account = create(:saving)
    visit savings_account_url(savings_account)
    click_link "New Deposit"
  end

  it 'with valid attributes' do
    fill_in "Amount", with: 100_000
    fill_in 'Date', with: Date.today
    fill_in 'Reference number', with: '909045'
    fill_in 'Date', with: Date.today

    click_button "Save Deposit"

    expect(page).to have_content('saved successfully')
  end

  it 'with invalid attributes' do
    click_button "Save Deposit"

    expect(page).to have_content("can't be blank")
  end
end
