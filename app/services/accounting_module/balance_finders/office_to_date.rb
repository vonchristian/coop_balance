module AccountingModule
  module BalanceFinders
    class OfficeToDate
      attr_reader :office, :from_date, :to_date, :amounts

      def initialize(args={})
        @office = args.fetch(:office)
        @from_date = 999.years.ago
        @to_date = args.fetch(:to_date)
        @amounts = args.fetch(:amounts)
      end

      def compute
        date_range = DateRange.new(from_date: from_date, to_date: to_date)
        
        amounts.joins(:entry).
        where('entries.office_id' => office.id).
        where('entries.entry_date' => date_range.start_date..date_range.end_date).
        total
      end
    end
  end
end
