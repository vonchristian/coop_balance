module LoansModule
  module Loans
    module Interest
      def interest_receivable_balance(args={})
        loan_product_interest_receivable_account.balance(args)
      end
      def interest_receivable_debits_balance(args={})
        loan_product_interest_receivable_account.debits_balance(args)
      end

      def total_interest_payments(args={})
        interest_revenue_account.credits_balance(args)
      end

      def balance(args={})
        loan.interest_revenue_account.balance(args)
      end

    end
  end
end
