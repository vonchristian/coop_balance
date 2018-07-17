require 'rails_helper'

describe 'New employee time deposit' do
  before(:each) do
    user = create(:user, role: 'teller')
    login_as(user, scope: :user )
    employee = create(:employee, role: 'manager')
    membership = create(:membership, memberable: employee)
    visit employee_time_deposits_url(employee)
    expect(page).to have_content("Time Deposits")
    click_link "New Time Deposit"
    debit_account = create(:asset, name: "Cash on Hand (Teller)")
    credit_account = create(:liability, name: "Time Deposits" )
  end
  it 'with valid attributes' do
    fill_in "Amount", with: 100_000
    fill_in 'Date', with: Date.today
    fill_in 'Reference number', with: '909045'
    fill_in 'Number of days', with: 90

    click_button "Save Time Deposit"

    expect(page).to have_content('saved successfully.')
  end
end
