require 'rails_helper'

describe 'New savings account closing' do
  before(:each) do
    cash_on_hand_account = create(:asset, name: "Cash on Hand (Teller)")
    user = create(:user, role: 'teller', cash_on_hand_account: cash_on_hand_account)
    login_as(user, scope: :user )
    savings_account_config = create(:savings_account_config)
    @savings_account = create(:saving)

    visit savings_account_url(@savings_account)
    click_link "New Deposit"
    fill_in "Amount", with: 100_000
    fill_in 'OR number', with: '909045'
    fill_in 'Date', with: Date.today

    click_button "Save Deposit"

    expect(@savings_account.balance).to eql 100_000
    visit savings_account_settings_url(@savings_account)
    click_link "Close Account"
  end
  it 'with valid attributes' do
    fill_in 'OR number', with: '909045'
    fill_in 'Date', with: Date.today

    click_button "Close Account"

    expect(page).to have_content('closed successfully')
    expect(@savings_account.balance).to eql 0
  end

  it 'with invalid attributes' do
    click_button "Close Account"

    expect(page).to have_content("can't be blank")
  end
end
