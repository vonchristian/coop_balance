require 'rails_helper'

module LoansModule
  module Loans
    describe CurrentLoan do
      it "#principal_account" do
        restructured_loan_account = create(:asset, name: "Loans Receivable Restructured ")

        loan_product = create(:loan_product, restructured_loan_account: restructured_loan_account)

        loan = create(:past_due_loan, loan_product: loan_product)

        expect(loan.principal_account).to eql restructured_loan_account
      end
    end
  end
end
