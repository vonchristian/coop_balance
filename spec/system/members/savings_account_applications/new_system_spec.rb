require 'rails_helper'
include ChosenSelect

describe 'New savings account application' do
  before(:each) do
    cooperative    = create(:cooperative)
    cash_account   = create(:asset, name: "Cash on Hand")
    teller         = create(:teller, cooperative: cooperative)
    member         = create(:member)
    saving_product = create(:saving_product, name: "Regular Savings", cooperative: cooperative)
    member.memberships.create!(cooperative: cooperative, membership_type: 'regular_member', account_number: SecureRandom.uuid, office: teller.office)
    teller.cash_accounts << cash_account
    create(:office_saving_product, office: teller.office, saving_product: saving_product)
    
    login_as(teller, scope: :user)
    visit member_savings_accounts_path(member)
    click_link "New Savings Account"
  end

  it "with valid attributes", js: true do
    select_from_chosen "Regular Savings", from: 'Saving product'
    fill_in "Date",             with: Date.current.strftime('%B %e, %Y')
    fill_in "Amount",           with: 5_000
    fill_in "Description",      with: "Opening of savings account"
    fill_in "Beneficiaries",    with: "Beneficiary"
    fill_in "Reference number", with: "909090"
    select_from_chosen "Cash on Hand", from: 'Cash Account'

    click_button "Proceed"

    expect(page).to have_content "created successfully"


    click_link "Confirm Transaction"

    expect(page).to have_content "opened successfully"

  end

  it "with invalid attributes" do
    click_button "Proceed"

    expect(page).to have_content("can't be blank")
  end
end
