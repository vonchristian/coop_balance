module LoansModule
  module Loans
    class CurrentLoan < LoansModule::Loan
      def principal_account
        loan_product.current_account
      end
    end
  end
end
