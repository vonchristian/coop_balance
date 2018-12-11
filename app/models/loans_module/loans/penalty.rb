module LoansModule
  module Loans
    module Penalty
      def penalties_debits_balance
         loan_penalties.total
      end
      def penalties_balance
        loan_penalties.total
      end
      def total_penalty_payments
        loan_product_penalty_revenue_account.credits_balance(commercial_document: self)
      end
      def payments_total(loan)
        loan.entries.map{|a| a.credit_amounts.distinct.where(account: loan.loan_product.penalty_account_id).sum(&:amount)}.sum
      end

      def compute(loan, schedule)
        #compute daily loan penalty
        loan.unpaid_balance_for(schedule) * (rate / 30)
      end

      def rate
       loan.loan_product.penalty_rate
      end
    end
  end
end
