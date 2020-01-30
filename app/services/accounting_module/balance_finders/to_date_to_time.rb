module AccountingModule
  module BalanceFinders
    class ToDateToTime
      attr_reader :from_date, :to_date, :to_time, :amounts, :from_time

      def initialize(amounts:, to_date:, to_time:)
        @amounts   ||= amounts
        @from_date = 999.years.ago
        @to_date   = to_date
        @to_time   = to_time
        @from_time = from_date
      end

      def compute
        date_range = DateRange.new(from_date: from_date, to_date: to_date)
        time_range = TimeRange.new(from_time: from_time, to_time: to_time)
        amounts.includes(:entry).
        where('entries.entry_date' => date_range.range).
        where('entries.created_at' => time_range.range).
        total
      end
    end
  end
end
