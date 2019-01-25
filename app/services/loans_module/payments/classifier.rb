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
        credit_amounts.where(commercial_document: loan).where(account: loan.principal_account).total
      end

      def interest
        if loan_product.current_interest_config.accrued?
          credit_amounts.where(commercial_document: loan).where(account: loan_product.current_interest_config_interest_revenue_account).total -
          debit_amounts.where(commercial_document: loan).where(account: loan_product.current_interest_config_accrued_income_account).total
        else
          credit_amounts.where(commercial_document: loan).where(account: loan_product.current_interest_config_interest_revenue_account).total
        end
      end
      def penalty
        credit_amounts.where(commercial_document: loan).where(account: loan_product.penalty_revenue_account).total
      end

      def total_cash_payment
        principal +
        interest +
        penalty
      end
    end
  end
end
