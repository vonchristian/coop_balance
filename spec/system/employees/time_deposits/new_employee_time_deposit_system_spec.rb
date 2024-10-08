require 'rails_helper'

describe 'New employee time deposit' do
  before do
    create(:time_deposit_product, name: 'Time Deposit (90 Days)')
    user = create(:user, role: 'teller')
    login_as(user, scope: :user)
    employee = create(:employee, role: 'general_manager')
    create(:membership, cooperator: employee)
    visit employee_time_deposits_url(employee)
    expect(page).to have_content('Time Deposits')
    click_link 'New Time Deposit'
    create(:asset, name: 'Cash on Hand (Teller)')
    create(:liability, name: 'Time Deposits')
  end

  it 'with valid attributes' do
    fill_in 'Date', with: Time.zone.today
    fill_in 'Amount', with: 100_000
    fill_in 'Reference number', with: '909045'
    fill_in 'Term (in months)', with: 3
    choose 'Time Deposit (90 Days)'
    click_button 'Save Time Deposit'

    expect(page).to have_content('saved successfully.')
  end
end
