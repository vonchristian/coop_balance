module StoreFrontModule
  module BalanceFinders
    class LineItemsStoreFront
      attr_reader :store_front, :line_items

      def initialize(args)
        @store_front = args[:store_front]
        @line_items  = args.fetch(:line_items)
      end

      def compute
        line_items.
        includes(:unit_of_measurement).
        with_orders.
        for_store_front(store_front).
        total_converted_quantity
      end
    end
  end
end
