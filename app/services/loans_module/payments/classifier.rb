module LoansModule
  module Payments
    class Classifier
      attr_reader :loan, :entry, :loan_product, :debit_amounts, :credit_amounts
      def initialize(args)
        @loan           = args.fetch(:loan)
        @entry          = args.fetch(:entry)
        @debit_amounts  = @entry.debit_amounts.not_cancelled
        @credit_amounts = @entry.credit_amounts.not_cancelled
        @loan_product   = @loan.loan_product
      end

      def principal
        credit_amounts.where(account: loan.receivable_account).total
      end

      def interest
        entry.amounts.where(account: loan.interest_revenue_account).total
      end

      def penalty
        credit_amounts.where(account: loan.penalty_revenue_account).total
      end

      def total_cash_payment
        principal.to_f +
        interest.to_f +
        penalty.to_f -
        accrued_interest.to_f
      end
    end
  end
end
