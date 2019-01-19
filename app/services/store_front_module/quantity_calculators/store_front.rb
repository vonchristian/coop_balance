module StoreFrontModule
  module QuantityCalculators
    class StoreFront
      attr_reader :line_items, :store_front

      def initialize(args)
        @line_items = args.fetch(:line_items)
        @store_front = args.fetch(:store_front)
      end

      def compute
        line_items.
        with_orders.
        for_store_front(store_front).
        includes(:unit_of_measurement).
        total_converted_quantity
      end
    end
  end
end
