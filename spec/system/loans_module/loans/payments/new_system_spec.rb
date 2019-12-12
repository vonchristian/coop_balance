require 'rails_helper'
include ChosenSelect
describe 'New loan payment' do
  before(:each) do
    teller                = create(:teller)
    loan_group            = create(:loan_aging_group, office: teller.office, start_num: 0, end_num: 0)
    cash                  = create(:asset, name: 'Cash on Hand')
    cash_account          = create(:employee_cash_account, employee: teller, cash_account: cash)
    loan_product          = create(:loan_product, cooperative: teller.cooperative)
    interest_config       = create(:interest_config, rate: 0.12, calculation_type: 'prededucted', loan_product: loan_product)
    member                = create(:member)
    receivable_account    = create(:asset)
    loan_application      = create(:loan_application, term: 12, loan_product: loan_product, borrower: member, receivable_account: receivable_account, office: teller.office, cooperative: teller.cooperative, mode_of_payment: 'lumpsum', application_date: Date.current, account_number: SecureRandom.uuid)
    voucher               = create(:voucher, description: 'loan disbursement', office: teller.office, cooperative: teller.cooperative, preparer: loan_application.preparer, payee: member)
    debit_voucher_amount  = create(:voucher_amount, recorder: teller, amount_type: 'debit', amount: 10_000, account: loan_application.receivable_account, voucher: voucher, cooperative: teller.cooperative, commercial_document: loan_application)
    credit_voucher_amount = create(:voucher_amount, recorder: teller, amount_type: 'credit', amount: 10_000, account: cash_account.cash_account, voucher: voucher, cooperative: teller.cooperative, commercial_document: loan_application)
    loan_application.update!(voucher: voucher)
    login_as(teller, scope: :user)
    visit new_loans_module_loan_application_disbursement_path(loan_application)

    fill_in 'Disbursement date', with: '30/3/2019'

    click_button 'Disburse Loan'

    loan = loan_application.loan
    amortization_schedule = create(:amortization_schedule, loan: loan, date: Date.current)

login_as(teller, scope: :user)
    visit loan_path(loan)

    click_link "Payments"
    click_link 'New Payment'

  end

  it 'with valid attributes', js: true do

    fill_in 'Date', with: Date.current
    select_from_chosen Date.current.strftime("%B, %Y"), from: 'Select Amortization Schedule to be paid.'
    fill_in 'Description', with: 'Loan payment'
    fill_in 'Principal amount', with: 500
    fill_in 'Interest amount', with: 50
    fill_in 'Penalty amount', with: 100
    fill_in 'Reference number', with: '42342'
    select_from_chosen 'Cash on Hand', from: 'Cash account'
    click_button 'Proceed'
    expect(page).to have_content('created successfully')

    click_link 'Confirm'

    expect(page).to have_content('saved successfully')
  end

  it 'with invalid attributes' do
    click_button 'Proceed'


    expect(page).to have_content("can't be blank")
  end

end
