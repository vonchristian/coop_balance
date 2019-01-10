module AccountingModule
  module BalanceFinders
    class AmountsCooperativeService < BaseBalanceFinder
      attr_reader :cooperative_service

      def post_initialize(args)
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
