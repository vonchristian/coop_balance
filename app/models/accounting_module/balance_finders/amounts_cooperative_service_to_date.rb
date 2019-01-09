module AccountingModule
  module BalanceFinders
    class AmountsCooperativeServiceToDate
      attr_reader :amounts, :cooperative_service, :to_date, :from_date

      def initialize(args)
        @amounts             = args.fetch(:amounts)
        @cooperative_service = args.fetch(:cooperative_service)
        @from_date           = 999.years.ago
        @to_date             = args.fetch(:to_date)
      end

      def compute
        date_range = DateRange.new(from_date: from_date, to_date: to_date)

        amounts.joins(:entry).
        where('entries.entry_date' => date_range.range).
        where('entries.cooperative_service_id' => cooperative_service.id).
        total
      end
    end
  end
end
