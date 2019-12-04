require 'rails_helper'

describe 'New time deposit application' do
  before(:each) do
    cooperative  = create(:cooperative)
    cash_account = create(:asset)
    user         = create(:user, role: 'teller', cooperative: cooperative)
    user.cash_accounts << cash_account
    time_deposit_product = create(:time_deposit_product, name: "Time Deposit (100,000)", cooperative: cooperative)
    member = create(:member)
    member.memberships.create!(cooperative: cooperative, membership_type: 'regular_member', account_number: SecureRandom.uuid)
    login_as(user, scope: :user)
    visit member_time_deposits_url(member)
    click_link "New Time Deposit"
  end

  it "with valid attributes" do
    fill_in "Date", with: Date.current
    fill_in "Reference number", with: "53345"
    fill_in "Description", with: "Time deposit"
    fill_in "Amount", with: 100_000
    select "Time Deposit (100,000)"
    fill_in "Term", with: 6
    fill_in "Beneficiaries", with: "Beneficiary"

    click_button "Proceed"
    expect(page).to have_content "created successfully"

    click_link "Confirm Transaction"

    expect(page).to have_content "saved successfully"

  end

  it "with invalid attributes" do
    click_button "Proceed"

    expect(page).to have_content "can't be blank"
  end
end
