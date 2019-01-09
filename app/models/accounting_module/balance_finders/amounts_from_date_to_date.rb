module AccountingModule
  module BalanceFinders
    class AmountsFromDateToDate
      attr_reader :amounts, :from_date, :to_date
      def initialize(args)
        @amounts = args.fetch(:amounts)
        @from_date = args.fetch(:from_date)
        @to_date   = args.fetch(:to_date)
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
