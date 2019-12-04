require 'rails_helper'
include ChosenSelect

feature "New loan application" do
  before(:each) do
    loan_product = create(:loan_product, name: "Regular Loan")
    user         = create(:loan_officer)
    member       = create(:member)
    member.memberships.create!(cooperative: user.cooperative, membership_type: 'regular_member', account_number: SecureRandom.uuid)

    login_as(user, scope: :user)

    visit member_loans_url(member)
    click_link 'New Loan Application'
  end

  scenario 'with valid attributes', js: true do
    fill_in 'Application date', with: Date.current.strftime('%B %e, %Y')
    select_from_chosen "Regular Loan", from: 'Select Type of Loan'
    fill_in "Loan amount", with: 10_000
    fill_in "Loan Term (in months)", with: 2
    choose "Lumpsum"
    fill_in "Purpose of loan", with: 'YEB'
    click_button 'Proceed'
    expect(page).to have_content("saved successfully")
  end

  scenario 'with invalid attributes' do
    click_button "Proceed"

    expect(page).to have_content("can't be blank")
  end
end
