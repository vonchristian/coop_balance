module LoansModule
  module Loans
    module Interest
      def total_interest_payments(args = {})
        interest_revenue_account.credits_balance(args)
      end

      def balance(args = {})
        interest_revenue_account.balance(args)
      end

      def total_interest_discounts
        loan_discounts.interest.total
      end
    end
  end
end
