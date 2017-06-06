require 'rails_helper'

feature "Create Loan Product" do
  before(:each) do
    user = FactoryGirl.create(:user)
    login_as(user, :scope => :user)
    visit loans_department_loan_products_url
    click_link 'New Loan Product'
  end

  scenario 'with valid attributes' do
    fill_in "Name", with: "Salary Loan"
    fill_in "Description", with: "description for loan"
    fill_in 'Interest Rate', with: 0.1
    choose "Monthly"

    click_button "Create Loan Product"

    expect(page).to have_content("created successfully")
  end

  scenario 'with invalid attributes' do
    click_button "Create Loan Product"

    expect(page).to have_content("can't be blank")
  end
end
