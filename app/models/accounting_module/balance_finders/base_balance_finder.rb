module AccountingModule
  module BalanceFinders
    class BaseBalanceFinder
      attr_reader :amounts

      def initialize(args)
        @amounts = args.fetch(:amounts)
        post_initialize(args)
      end
      def post_initialize(args)
      end
    end
  end
end
