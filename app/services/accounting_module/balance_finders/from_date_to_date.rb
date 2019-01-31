module AccountingModule
  module BalanceFinders
    class FromDateToDate
      attr_reader  :from_date, :to_date, :amounts

      def initialize(args={})
        @amounts   = args.fetch(:amounts)
        @from_date = args.fetch(:from_date)
        @to_date   = args.fetch(:to_date)
      end

      def compute
        date_range = DateRange.new(from_date: from_date, to_date: to_date)
        amounts.joins(:entry).
        where('entries.entry_date' => date_range.start_date..date_range.end_date).
        total
      end
    end
  end
end