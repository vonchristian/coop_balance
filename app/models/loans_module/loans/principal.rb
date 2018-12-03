module LoansModule
  module Loans
    module Principal
      
      def principal_balance
        principal_account.balance(commercial_document: self)
      end

      def principal_debits_balance
        loan_product.loans_receivable_current_account.debits_balance(commercial_document: self)
      end

       def principal_credits_balance
        loan_product.loans_receivable_current_account.credits_balance(commercial_document: self)
      end
    end
  end
end
