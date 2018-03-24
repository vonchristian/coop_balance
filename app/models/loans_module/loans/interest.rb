module LoansModule
  module Loans
    module Interest
      def interest_receivable_balance
        loan_product_interest_receivable_account.debits_balance(commercial_document: self)
      end
      def interest_receivable_debits_balance
        loan_product_interest_receivable_account.debits_balance(commercial_document: self)
      end
      def interest_payments
        loan_product_interest_receivable_account.credits_balance(commercial_document: self)
      end
      def payments_total
        loan.entries.map{|a| a.credit_amounts.distinct.where(account: loan_product.interest_account).sum(&:amount)}.sum
      end

      def balance
        loan.loan_product.interest_account.balance(commercial_document: self)
      end

      def compute(schedule)
        #compute daily loan penalty
        unpaid_balance_for(schedule) * (rate / 30)
      end

      def rate
       loan.loan_product.interest_rate
      end

      def unearned_interests
        loan_product_unearned_interest_income_account.balance(commercial_document: self)
      end
    end
  end
end
