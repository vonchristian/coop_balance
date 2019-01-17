module StoreFrontModule
  module QuantityCalculators
    class DefaultQuantityCalculator
      attr_reader :line_items

      def initialize(args)
        @line_items = args.fetch(:line_items)
      end
      def compute
        line_items.total_converted_quantity
      end
    end
  end
end
