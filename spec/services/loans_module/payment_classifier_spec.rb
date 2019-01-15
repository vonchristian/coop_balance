require 'rails_helper'

module LoansModule
  describe PaymentClassifier do

    it "#returns the correct principal, interest, penalty and total cash payment" do
      cooperative = create(:cooperative)
      employee = create(:employee, cooperative: cooperative)
      cash_on_hand = create(:asset)
      employee.cash_accounts << cash_on_hand
      loan_product = create(:loan_product)
      loan = create(:loan, loan_product: loan_product, status: 'current_loan')
      origin_entry = create(:origin_entry)
      payment = build(:entry, description: "Loan payment", previous_entry: origin_entry)
      principal = build(:credit_amount, amount: 1000, commercial_document: loan,  account: loan_product.current_account)
      interest  = build(:credit_amount, amount: 500, commercial_document: loan, account: loan_product.current_interest_config_interest_revenue_account)
      penalty   = build(:credit_amount, amount: 100, commercial_document: loan,  account: loan_product.penalty_revenue_account)
      cash      = build(:debit_amount, amount: 1600, commercial_document: loan,  account: cash_on_hand)
      payment.credit_amounts << principal
      payment.credit_amounts << interest
      payment.credit_amounts << penalty
      payment.debit_amounts  << cash

      payment.save!

      expect(described_class.new(entry: payment, loan: loan).principal).to eql 1_000
      expect(described_class.new(entry: payment, loan: loan).interest).to eql 500
      expect(described_class.new(entry: payment, loan: loan).penalty).to eql 100
      expect(described_class.new(entry: payment, loan: loan).total_cash_payment).to eql 1_600



    end
  end
end
