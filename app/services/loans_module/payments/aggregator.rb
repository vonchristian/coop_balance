module LoansModule
  module Payments
    class Aggregator
      attr_reader :from_date, :to_date, :loan_products, :loan_product
      def initialize(args)
        @collections = args.fetch(:collections)
        @from_date = args[:from_date]
        @to_date   = args[:to_date]
        @cooperative = args.fetch(:cooperative)
        @loan_products = @cooperative.loan_products
        @loan_product = args[:loan_product]
      end

      def total_principals
        if loan_product.present?
          loan_product.principal_accounts.credits_balance(from_date: from_date, to_date: to_date)
        else
          loan_products.principal_accounts.credits_balance(from_date: from_date, to_date: to_date)
        end
      end

      def total_interests
        if loan_product.present?
          loan_product.interest_revenue_account.credits_balance(from_date: from_date, to_date: to_date) -
          accrued_income_account_for_loan_product
        else
          loan_products.interest_revenue_accounts.credits_balance(from_date: from_date, to_date: to_date) -
          loan_products.accrued_income_accounts.debits_balance(from_date: from_date, to_date: to_date)
        end
      end

      def total_penalties
        if loan_product.present?
          loan_product.penalty_revenue_account.credits_balance(from_date: from_date, to_date: to_date)
        else
          loan_products.penalty_revenue_accounts.credits_balance(from_date: from_date, to_date: to_date)
        end
      end

      def total_cash_payments
        total_principals + total_interests + total_penalties
      end

      def accrued_income_account_for_loan_product
        if loan_product.current_interest_config.accrued_income_account.present?
          loan_product.current_interest_config.accrued_income_account.debits_balance(from_date: from_date, to_date: to_date)
        else
          0
        end
      end
    end
  end
end
