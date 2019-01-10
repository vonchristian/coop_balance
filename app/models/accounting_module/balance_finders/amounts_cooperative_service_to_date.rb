module AccountingModule
  module BalanceFinders
    class AmountsCooperativeServiceToDate < BaseBalanceFinder
      attr_reader  :cooperative_service, :to_date, :from_date

      def post_initialize(args)
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
