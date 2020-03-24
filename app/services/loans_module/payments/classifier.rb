module LoansModule
  module Payments
    class Classifier
      attr_reader :loan, :entry, :credit_amounts
      def initialize(loan:, entry:)
        @loan           = loan
        @entry          = entry 
        @credit_amounts = @entry.credit_amounts.not_cancelled
      end

      def principal
        credit_amounts.where(account: loan.receivable_account).total
      end

      def interest
        credit_amounts.where(account: loan.interest_revenue_account).total
      end

      def penalty
        credit_amounts.where(account: loan.penalty_revenue_account).total
      end

      def total_cash_payment
        principal.to_f +
        interest.to_f +
        penalty.to_f 
      end
    end
  end
end
