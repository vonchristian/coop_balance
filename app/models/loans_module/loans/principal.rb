module LoansModule
  module Loans
    module Principal
      def principal_balance
        if disbursed? || forwarded_loan?
          loan_product.loans_receivable_current_account.balance(commercial_document: self)
        else
          loan_amount
        end
      end
      def principal_debits_balance
        loan_product.loans_receivable_current_account.debits_balance(commercial_document: self)
      end
       def principal_credits_balance
        loan_product.loans_receivable_current_account.credits_balance(commercial_document: self)
      end

      def principal_payments
        loan_product.loans_receivable_current_account.credits_balance(commercial_document: self)
      end

      def total_unpaid_principal_for(date)
        amortized_principal_for(date) - paid_principal_for(date)
      end

      def paid_principal_for(date)
        loan_product_account.credit_entries.where(commercial_document: self)
      end
      def payments_total(loan)
        loan.loan_product.account.debits_balance(options)
      end

      def balance(loan)
        loan.loan_product.account.balance(commercial_document_id: loan.id)
      end

      def compute(loan, schedule)
        #compute daily loan penalty
        loan.unpaid_balance_for(schedule) * (rate / 30)
      end

      def rate
        loan.loan_product.interest_rate
      end
    end
  end
end
