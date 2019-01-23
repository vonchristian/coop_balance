module SavingsModule
  module InterestRateDivisors
    class Annually
      attr_reader :saving_product

      def initialize(args)
        @saving_product = args.fetch(:saving_product)
      end

      def rate_divisor
        1.0
      end
    end
  end
end
