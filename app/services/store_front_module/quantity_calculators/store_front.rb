module StoreFrontModule
  module QuantityCalculators
    class StoreFront
      attr_reader :line_items, :store_front

      def initialize(args)
        @line_items = args.fetch(:line_items)
        @store_front = args.fetch(:store_front)
      end

      def compute
        store_front.line_items.
        total_converted_quantity
      end
    end
  end
end
