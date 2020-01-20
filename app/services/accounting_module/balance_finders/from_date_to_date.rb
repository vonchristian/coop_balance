module AccountingModule
  module BalanceFinders
    class FromDateToDate
      attr_reader  :from_date, :to_date, :amounts

      def initialize(from_date:, to_date:, amounts:)
        @amounts   ||= amounts
        @from_date = from_date
        @to_date   = to_date
      end

      def compute
        date_range = DateRange.new(from_date: from_date, to_date: to_date)
        amounts.includes(:entry).where('entries.entry_date' => date_range.range).total

      end
    end
  end
end
