module LoansModule
  module Loans
    class RestructuredLoan < LoansModule::Loan
      def principal_account
        # loan_product.restructured_loan_account
      end
    end
  end
end
