module LoansModule
  module Payments
    class Aggregator
      attr_reader :from_date, :to_date, :loan_products
      def initialize(args)
        @collections = args.fetch(:collections)
        @from_date = args[:from_date]
        @to_date   = args[:to_date]
        @cooperative = args.fetch(:cooperative)
        @loan_products = @cooperative.loan_products
      end

      def total_principals
        loan_products.principal_accounts.credits_balance(from_date: from_date, to_date: to_date)
      end

      def total_interests
        loan_products.current_interest_revenue_accounts.credits_balance(from_date: from_date, to_date: to_date)
      end

      def total_penalties
        loan_products.penalty_revenue_accounts.credits_balance(from_date: from_date, to_date: to_date)
      end

      def total_cash_payments
        collections.total_cash_amount
      end
    end
  end
end