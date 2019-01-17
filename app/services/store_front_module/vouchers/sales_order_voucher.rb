module StoreFrontModule
  module Vouchers
    class SalesOrderVoucher
      attr_reader :order

      def initialize(args)
        @order = args.fetch(:order)
      end
    end
  end
end
