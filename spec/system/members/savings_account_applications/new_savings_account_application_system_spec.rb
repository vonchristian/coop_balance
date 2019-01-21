require 'rails_helper'

describe 'New savings account application' do
  before(:each) do
    cooperative = create(:cooperative)
    origin_entry = create(:origin_entry, cooperative: cooperative)
    cash_account = create(:asset, name: "Cash on Hand")
    user = create(:user, role: 'teller', cooperative: cooperative)
    user.cash_accounts << cash_account
    saving_product = create(:saving_product, name: "Regular Savings", cooperative: cooperative)
    member = create(:member)
    member.memberships.create(cooperative: cooperative, membership_type: 'regular_member')
    login_as(user, scope: :user )
    visit member_savings_accounts_url(member)
    click_link "New Saving"
  end

  it "with valid attributes" do
    fill_in "Date", with: Date.current
    choose "Regular Savings"
    fill_in "Amount", with: 5_000
    fill_in "Description", with: "Opening of savings account"
    fill_in "Beneficiaries", with: "Beneficiary"
    fill_in "Reference number", with: "909090"
    select "Cash on Hand"

    click_button "Proceed"

    expect(page).to have_content "created successfully"


    click_link "Confirm"

    expect(page).to have_content "opened successfully"

  end

  it "with invalid attributes" do
    click_button "Proceed"

    expect(page).to have_content("can't be blank")
  end
end
