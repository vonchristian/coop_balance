require 'rails_helper'

feature "New member loan system spec" do
  before(:each) do
    loan_product = create(:loan_product_with_interest_config, name: "Regular Loan")
    user = create(:loan_officer)
    login_as(user, :scope => :user)
    member = create(:member)
    visit member_loans_url(member)
    click_link 'New Loan Application'
  end

  scenario 'with valid attributes' do
    select "Regular Loan"
    fill_in "Loan amount", with: 10_000
    fill_in "Loan Term (in months)", with: 2
    choose "Lumpsum"
    fill_in "Application date", with: Date.today
    click_button 'Proceed'
    expect(page).to have_content("saved successfully")
  end

  scenario 'with invalid attributes' do
    click_button "Proceed"

    expect(page).to have_content("can't be blank")
  end
end
