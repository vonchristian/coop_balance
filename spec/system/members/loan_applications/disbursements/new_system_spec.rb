require 'rails_helper'

describe 'New loan application disbursement' do
  before(:each) do
    teller = create(:teller)
    cash  = create(:asset)
    teller.cash_accounts << cash
    loan_product = create(:loan_product)
    create(:office_loan_product, office: teller.office, loan_product: loan_product)
    loan_application = create(:loan_application, loan_product: loan_product, mode_of_payment: 'monthly', office: teller.office, voucher_id: nil)

    @voucher = build(:voucher, office: teller.office)
    @voucher.voucher_amounts.debit.build(amount: 100_000, account: loan_application.receivable_account)
    @voucher.voucher_amounts.credit.build(amount: 90_000, account: cash)
    @voucher.voucher_amounts.debit.build(amount: 10_000, account: loan_application.interest_revenue_account)
    @voucher.save!

    loan_application.update(voucher: @voucher)



    login_as(teller, scope: :user)
    visit new_loans_module_loan_application_disbursement_path(loan_application_id: loan_application.id, voucher_id: @voucher.id)
  end

  it 'with valid attributes', js: true do
    fill_in 'Disbursement date', with: Date.current

    click_button 'Disburse Loan'

    expect(page).to have_content('disbursed successfully')
  end
end
