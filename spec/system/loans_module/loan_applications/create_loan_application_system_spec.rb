require 'rails_helper'

feature 'Create Loan application' do
  before(:each) do
    Rails.application.load_seed
    user = create(:loan_officer)
    login_as(user, :scope => :user)
    borrower = create(:member, first_name: "Juan", last_name: "Cruz")

    loan_product = create(:loan_product_with_interest_config, name: "Salary Loan")
    visit new_loans_module_loan_application_url
  end

  scenario 'with valid attributes' do
    select "Juan Cruz", :from => "borrowerSelect"
    select "Salary Loan", :from => "loanProductSelect"
    fill_in "Loan amount", with: 100_000
    fill_in "Term", with: 12
    choose 'Monthly'
    click_button "Proceed"

    expect(page).to have_content 'saved successfully.'
  end
end

