require 'rails_helper'
include ChosenSelect

describe 'New time deposit application' do
  before(:each) do
    cooperative  = create(:cooperative)
    cash_account = create(:asset, name: 'Cash on Hand')
    user         = create(:user, role: 'teller', cooperative: cooperative)
    user.employee_cash_accounts.create!(cash_account: cash_account, cooperative: cooperative)
    time_deposit_product = create(:time_deposit_product, name: "Time Deposit (100,000)", cooperative: cooperative)
    member = create(:member)
    member.memberships.create!(cooperative: user.cooperative, membership_type: 'regular_member', account_number: SecureRandom.uuid, membership_date: Date.current, office: user.office)
    create(:office_time_deposit_product, office: user.office, time_deposit_product: time_deposit_product)
    login_as(user, scope: :user)
    visit member_time_deposits_path(member)
    click_link "New Time Deposit"
  end

  it "with valid attributes", js: true do
    select_from_chosen 'Cash on Hand', from: 'Cash Account'
    fill_in "Date", with: Date.current
    fill_in "Reference number", with: "53345"
    fill_in "Description", with: "Time deposit"
    fill_in "Amount", with: 100_000
    select "Time Deposit (100,000)"
    page.execute_script "window.scrollBy(0,10000)"

    fill_in "Term", with: 6
    fill_in "Beneficiaries", with: "Beneficiary"
    page.execute_script "window.scrollBy(0,10000)"
    click_button "Proceed"
    expect(page).to have_content "created successfully"

    click_link "Confirm Transaction"

    expect(page).to have_content "confirmed successfully"

  end

  it "with invalid attributes" do
    click_button "Proceed"

    expect(page).to have_content "can't be blank"
  end
end
