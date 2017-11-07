require 'rails_helper'

feature "Create Loan Product" do
  before(:each) do
    user = FactoryBot.create(:user)
    login_as(user, :scope => :user)
    visit loans_module_loan_products_url
    click_link 'New Loan Product'
  end

  scenario 'with valid attributes' do
    account = create(:account, type: 'AccountingModule::Asset', name: "Loans Receivable")

    fill_in "Name", with: "Salary Loan"
    fill_in "Description", with: "description for loan"
    fill_in 'Interest Rate', with: 0.1
  find("option[value='Loans Receivable']").click

    click_button "Create Loan Product"

    expect(page).to have_content("created successfully")
  end

  scenario 'with invalid attributes' do
    click_button "Create Loan Product"

    expect(page).to have_content("can't be blank")
  end
end
