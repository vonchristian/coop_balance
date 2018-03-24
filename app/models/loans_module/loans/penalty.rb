module LoansModule
  module Loans
    module Penalty
      def penalties_debits_balance
        loan_product_penalty_receivable_account.debits_balance(commercial_document: self)
      end
      def penalties_balance
        loan_product_penalty_receivable_account.balance(commercial_document: self)
      end
      def penalty_payments
        loan_product_penalty_receivable_account.credits_balance(commercial_document: self)
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
