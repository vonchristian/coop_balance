require 'rails_helper'

describe 'New savings account closing' do
  before do
    cash = create(:asset, name: 'Cash on Hand (Teller)')
    user = create(:user, role: 'teller')
    user.cash_accounts << cash
    login_as(user, scope: :user)

    @savings_account = create(:saving, office: user.office)

    visit savings_account_url(@savings_account)
    click_link 'Deposit'
    fill_in 'Amount', with: 100_000
    fill_in 'Reference Number', with: '909045'
    fill_in 'Date', with: Time.zone.today

    click_button 'Proceed'
    click_link 'Confirm Transaction'

    expect(@savings_account.balance).to be 100_000
    visit savings_account_settings_url(@savings_account)
    click_link 'Close Account'
  end

  it 'with valid attributes' do
    fill_in 'Reference number', with: '909045'
    fill_in 'Date', with: Time.zone.today

    click_button 'Close Account'

    expect(page).to have_content('created successfully')
    click_link 'Confirm Transaction'

    expect(page).to have_content('confirmed successfully')

    expect(@savings_account.balance).to be 0
  end

  it 'with invalid attributes' do
    click_button 'Close Account'

    expect(page).to have_content("can't be blank")
  end
end
