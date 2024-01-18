require 'rails_helper'
include ChosenSelect
describe 'New office loan product loan aging group' do
  before do
    loan_officer        = create(:loan_officer)
    office              = loan_officer.office
    loan_product        = create(:loan_product, name: 'Regular Loan')
    create(:office_loan_product, office: office, loan_product: loan_product)
    create(:loan_aging_group, office: office, start_num: 0, end_num: 0)
    login_as(loan_officer, scope: :user)
    visit loans_module_settings_path
    click_link 'Set Office Loan Product'
  end

  it 'valid', :js do
    select_from_chosen 'Regular Loan', from: 'Loan product'
    select_from_chosen 'Loans Receivables Current - Regular Loan', from: 'Account category'

    click_button 'Save'

    expect(page).to have_content('saved successfully')
  end
end
