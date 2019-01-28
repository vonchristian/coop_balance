module AccountingModule
  module BalanceFinders
    class CooperativeService
      attr_reader :cooperative_service, :amounts

      def initialize(args)
        @amounts = args.fetch(:amounts)
        @cooperative_service = args.fetch(:cooperative_service)
      end

      def compute
        amounts.joins(:entry).
        where('entries.cooperative_service_id' => cooperative_service.id).
        total
      end
    end
  end
end
