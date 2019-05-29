module AccountingModule
  module BalanceFinders
    class CooperativeServiceFromDateToDate
      attr_reader  :cooperative_service_id, :to_date, :from_date, :amounts

      def initialize(args={})
        @amounts             = args.fetch(:amounts)
        @cooperative_service_id = args.fetch(:cooperative_service_id)
        @from_date           = args.fetch(:from_date)
        @to_date             = args.fetch(:to_date)
      end

      def compute
        date_range = DateRange.new(from_date: from_date, to_date: to_date)
        amounts.joins(:entry).
        where('entries.entry_date' => date_range.range).
        where('entries.cooperative_service_id' => cooperative_service_id).
        total
      end
    end
  end
end
