module StoreFrontModule
  module BalanceFinders
    class StoreFront
      attr_reader :store_front, :line_items

      def initialize(args)
        @store_front = args[:store_front]
        @line_items  = args.fetch(:line_items)
      end

      def compute
        line_items.
        includes(:order).
        where('orders.store_front_id' => store_front.id).
        total_converted_quantity
      end
    end
  end
end
