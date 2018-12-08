module LoansModule
  module Loans
    module Principal

      def principal_balance(args={})
        principal_account.balance(commercial_document: self)
      end

      def principal_debits_balance(args={})
        loan_product.loans_receivable_current_account.debits_balance(commercial_document: self)
      end

      def principal_credits_balance(args={})
        loan_product.loans_receivable_current_account.credits_balance(commercial_document: self)
      end
    end
  end
end
