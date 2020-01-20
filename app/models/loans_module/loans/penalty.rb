module LoansModule
  module Loans
    module Penalty
      def penalties_debits_balance
         loan_penalties.total
      end
      def penalties_balance
        loan_penalties.total
      end
      def total_penalty_payments(args={})
        penalty_revenue_account.credits_balance(args)
      end
    end
  end
end
