require 'rails_helper'

feature 'New savings account deposit' do
  before(:each) do
    cash_on_hand_account = create(:asset, name: "Cash on Hand (Teller)")
    user = create(:user, role: 'teller')
    user.cash_accounts << cash_on_hand_account
    login_as(user, scope: :user )
    savings_account = create(:saving, office: user.office)
    visit savings_account_path(savings_account)
    click_link "Deposit"
  end
  scenario 'with valid attributes', js: true do
    fill_in "Amount",    with: 100_000
    fill_in 'Date',      with: Date.today
    fill_in 'Reference Number', with: '909045'
    fill_in 'Date',      with: Date.today
    
    click_button "Proceed"

    expect(page).to have_content('created successfully')

    click_link 'Confirm Transaction'
  end

  scenario 'with invalid attributes' do
    click_button "Proceed"

    expect(page).to have_content("can't be blank")
  end
end
