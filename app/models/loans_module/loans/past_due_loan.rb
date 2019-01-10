module LoansModule
  module Loans
    class PastDueLoan < LoansModule::Loan
      def principal_account
        loan_product.past_due_account
      end
    end
  end
end
