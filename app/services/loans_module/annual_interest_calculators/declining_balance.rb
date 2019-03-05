module LoansModule
  module AnnualInterestCalculators
    class DecliningBalance
      attr_reader :from_date, :to_date

      def initialize(args={})
        @from_date = args.fetch(:from_date)
        @to_date   = args.fetch(:to_date)
      end

      def calculate
        amortization_schedules.
        scheduled_for(from_date: from_date, to_date: to_date).
        total_interest
      end
    end
  end
end
