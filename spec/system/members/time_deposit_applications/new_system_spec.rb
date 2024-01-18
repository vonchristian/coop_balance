require 'rails_helper'
include ChosenSelect

describe 'New time deposit application' do
  before do
    cooperative  = create(:cooperative)
    cash_account = create(:asset, name: 'Cash on Hand')
    user         = create(:user, role: 'teller', cooperative: cooperative)
    user.employee_cash_accounts.create!(cash_account: cash_account)
    time_deposit_product = create(:time_deposit_product, name: 'Time Deposit (100,000)', cooperative: cooperative)
    member = create(:member)
    membership_category = create(:membership_category, cooperative: user.cooperative)
    member.memberships.create!(cooperative: user.cooperative, membership_category: membership_category, account_number: SecureRandom.uuid, membership_date: Date.current, office: user.office)
    create(:office_time_deposit_product, office: user.office, time_deposit_product: time_deposit_product)
    login_as(user, scope: :user)
    visit member_time_deposits_path(member)
    click_link 'New Time Deposit'
  end

  it 'with valid attributes', :js do
    select_from_chosen 'Cash on Hand', from: 'Cash Account'
    fill_in 'Date', with: Date.current
    fill_in 'Reference number', with: '53345'
    fill_in 'Description', with: 'Time deposit'
    fill_in 'Amount', with: 100_000
    select 'Time Deposit (100,000)'
    page.execute_script 'window.scrollBy(0,10000)'

    fill_in 'Term (Number of days)', with: 180
    fill_in 'Beneficiaries', with: 'Beneficiary'
    page.execute_script 'window.scrollBy(0,10000)'
    click_button 'Proceed'
    expect(page).to have_content 'created successfully'

    click_link 'Confirm Transaction'

    expect(page).to have_content 'confirmed successfully'
  end

  it 'with invalid attributes' do
    click_button 'Proceed'

    expect(page).to have_content "can't be blank"
  end
end
