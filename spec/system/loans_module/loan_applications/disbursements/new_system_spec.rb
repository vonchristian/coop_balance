require 'rails_helper'
include ChosenSelect

describe "New loan application", type: :system do
  before(:each) do
    cash                            = create(:asset, name: 'Cash on Hand')
    cooperative                     = create(:cooperative)
    office                          = create(:office, cooperative: cooperative)
    loan_officer                    = create(:loan_officer, cooperative: cooperative, office: office)
    teller                          = create(:teller, office: office, cooperative: cooperative)
    amortization_type               = create(:amortization_type, calculation_type: 'straight_line', repayment_calculation_type: 'equal_principal')
    loan_product                    = create(:loan_product, name: "Regular Loan", amortization_type: amortization_type)
    interest_config                 = create(:interest_config, calculation_type: 'prededucted', rate: 0.12, loan_product: loan_product)
    interest_prededuction           = create(:interest_prededuction, calculation_type: 'percent_based', rate: 1, loan_product: loan_product)
    loan_aging_group                = create(:loan_aging_group, start_num: 0, end_num: 0, office: office)
    office_loan_product             = create(:office_loan_product, loan_product: loan_product, office: loan_officer.office)
    office_loan_product_aging_group = create(:office_loan_product_aging_group, office_loan_product: office_loan_product, loan_aging_group: loan_aging_group)
    member                          = create(:member)
    membership_category             = create(:membership_category, cooperative: cooperative)
    member.memberships.create!(cooperative: loan_officer.cooperative, cooperator: member, membership_category: membership_category,  account_number: SecureRandom.uuid, office: loan_officer.office, membership_date: Date.current)
    teller.cash_accounts << cash

    login_as(loan_officer, scope: :user)
    visit member_loans_path(member)
    click_link 'New Loan Application'
  end

  it 'with valid attributes', js: true do
    select_from_chosen "Regular Loan", from: 'Select Type of Loan'
    fill_in "Loan amount",             with: 100_000
    fill_in "Term (Number of days)", with: 730
    page.execute_script "window.scrollBy(0,10000)"

    choose "Monthly"
    page.execute_script "window.scrollBy(0,10000)"

    fill_in "Purpose of Loan", with: 'Regular Loan'
    fill_in 'Application date', with: Date.current.strftime('%B %e, %Y')

    click_button 'Proceed'

    expect(page).to have_content("saved successfully")

    fill_in 'Date', with: Date.current
    page.execute_script "window.scrollBy(0,10000)"

    select 'Cash on Hand',      from: 'Cash account'
    fill_in 'Reference number', with: '232'
    click_button 'Create Voucher'

    expect(page).to have_content("saved successfully")
  end

  it 'with invalid attributes' do
    click_button "Proceed"

    expect(page).to have_content("can't be blank")
  end
end
