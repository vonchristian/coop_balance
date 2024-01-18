require 'rails_helper'

module LoansModule
  module Payments
    describe Classifier do
      it '#returns the correct principal, interest, accrued, penalty and total cash payment' do
        cooperative      = create(:cooperative)
        employee         = create(:employee, cooperative: cooperative)
        cash_on_hand     = create(:asset)
        employee.cash_accounts << cash_on_hand
        loan_product     = create(:loan_product)
        loan             = create(:loan, loan_product: loan_product, status: 'current_loan')
        payment          = build(:entry, description: 'Loan payment')
        principal        = build(:credit_amount, amount: 1000, account: loan.receivable_account)
        interest         = build(:credit_amount, amount: 100,  account: loan.interest_revenue_account)
        penalty          = build(:credit_amount, amount: 100, account: loan.penalty_revenue_account)
        cash             = build(:debit_amount, amount: 1100, account: cash_on_hand)
        payment.credit_amounts << principal
        payment.credit_amounts << interest
        payment.credit_amounts << penalty
        payment.debit_amounts  << cash

        payment.save!

        expect(described_class.new(entry: payment, loan: loan).principal).to be 1_000
        expect(described_class.new(entry: payment, loan: loan).interest).to be 100
        expect(described_class.new(entry: payment, loan: loan).penalty).to be 100
        expect(described_class.new(entry: payment, loan: loan).total_cash_payment).to eq 1_200
      end
    end
  end
end
