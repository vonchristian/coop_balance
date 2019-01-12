require 'rails_helper'

module LoansModule
  module Loans
    describe CurrentLoan do
      it "#principal_account" do
        loans_receivable_past_due_account = create(:asset, name: "Loans Receivable Past Due ")

        loan_product = create(:loan_product, loans_receivable_past_due_account: loans_receivable_past_due_account)

        loan = create(:past_due_loan, loan_product: loan_product)

        expect(loan.principal_account).to eql loans_receivable_past_due_account
      end
    end
  end
end
