module AccountingModule
  module BalanceFinders
    class AmountsToDate < BaseBalanceFinder
      attr_reader :from_date, :to_date

      def post_initialize(args)
        @from_date = 999.years.ago
        @to_date = args.fetch(:to_date)
      end

      def compute
        date_range = DateRange.new(from_date: from_date, to_date: to_date)
        amounts.joins(:entry).
        where('entries.entry_date' => date_range.range).
        total
      end
    end
  end
end
