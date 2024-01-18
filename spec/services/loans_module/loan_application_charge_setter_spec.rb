require 'rails_helper'

module LoansModule
  describe LoanApplicationChargeSetter do
    let!(:loan_protection_plan_provider)     { create(:loan_protection_plan_provider, business_name: 'CLIMBS', rate: 1.35) }
    let!(:add_on_straight_line_loan_product) { create(:add_on_straight_line_loan_product, loan_protection_plan_provider: loan_protection_plan_provider) }
    let!(:loan_application)                  { create(:loan_application, loan_amount: 100_000, term: 12, loan_product: add_on_straight_line_loan_product) }
    let!(:service_charge)                    { create(:loan_product_charge, name: 'Service Fee', loan_product: add_on_straight_line_loan_product, rate: 0.03, charge_type: 'percent_based') }
    let!(:filing_fee)                        { create(:loan_product_charge, name: 'Filing Fee', loan_product: add_on_straight_line_loan_product, amount: 100, charge_type: 'amount_based') }

    before do
      described_class.new(loan_application: loan_application, loan_product: add_on_straight_line_loan_product).create_charges!
    end

    it '#create_charges_based_on_loan_product' do
      expect(loan_application.voucher_amounts.credit.pluck(:description)).to include 'Service Fee'
      expect(loan_application.voucher_amounts.credit.pluck(:description)).to include 'Filing Fee'
      expect(loan_application.voucher_amounts.find_by(description: 'Service Fee').amount.amount).to be 3_000
      expect(loan_application.voucher_amounts.find_by(description: 'Filing Fee').amount.amount).to be 100

      expect(loan_application.voucher_amounts.credit.pluck(:account_id)).to include service_charge.account_id
      expect(loan_application.voucher_amounts.credit.pluck(:account_id)).to include service_charge.account_id
    end

    it '#create_loan_protection_fund' do
      expect(loan_application.voucher_amounts.credit.pluck(:description)).to include 'Loan Protection Fund'
      expect(loan_application.voucher_amounts.credit.pluck(:account_id)).to include loan_protection_plan_provider.accounts_payable_id
      expect(loan_application.voucher_amounts.find_by(description: 'Loan Protection Fund').amount.amount).to be 1_620
    end
  end
end
