require 'rails_helper'

module LoansModule
  module Loans
    describe CurrentLoan do
      it "#principal_account" do
        loans_receivable_current_account = create(:asset, name: "Loans Receivable Current")

        loan_product = create(:loan_product, loans_receivable_current_account: loans_receivable_current_account)

        loan = create(:current_loan, loan_product: loan_product)

        expect(loan.principal_account).to eql loans_receivable_current_account
      end
    end
  end
end 
