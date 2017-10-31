require 'rails_helper'

describe 'New Loan' do
  before(:each) do
    user = create(:user, role: 'loan_officer')
    login_as(user, scope: :user)
    visit new_loans_module_loan_application_url
    @loan_product = create(:loan_product)
  end

  it 'with valid attributes' do
    save_and_open_page
    select @loan_product.name.titleize, from: "Select Type of Loan"
  end
end
