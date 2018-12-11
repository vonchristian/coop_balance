module LoansModule
  module Loans
    module Interest
      def interest_receivable_balance(args={})
        loan_product_interest_receivable_account.balance(commercial_document: self)
      end
      def interest_receivable_debits_balance(args={})
        loan_product_interest_receivable_account.debits_balance(commercial_document: self)
      end

      def total_interest_payments
        loan_product_interest_revenue_account.credits_balance(commercial_document: self)
      end

      def balance
        loan.loan_product.interest_account.balance(commercial_document: self)
      end

    end
  end
end
