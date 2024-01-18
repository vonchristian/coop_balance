module SavingsModule
  module BalanceAveragers
    class Monthly
      attr_reader :saving, :to_date

      def initialize(args)
        @saving  = args.fetch(:saving)
        @to_date = args.fetch(:to_date)
      end

      def averaged_balance
        monthly_balances.sum / 12.0
      end

      private

      def end_date
        if to_date.is_a?(Date) || to_date.is_a?(Time)
          to_date.end_of_month.to_date
        else
          DateTime.parse(to_date).end_of_month.to_date
        end
      end

      def start_date
        if to_date.is_a?(Date) || to_date.is_a?(Time)
          to_date.beginning_of_month.to_date
        else
          DateTime.parse(to_date).beginning_of_month.to_date
        end
      end

      def monthly_balances
        balances = []
        months   = []
        (start_date..end_date).each do |date|
          months << date.end_of_month
        end

        months.uniq.each do |month|
          balances << saving.balance(to_date: month.end_of_month).to_f
        end
        balances
      end
    end
  end
end
