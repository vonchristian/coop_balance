module SavingsModule
  module InterestRateDivisors
    class Daily
      attr_reader :saving_product

      def initialize(args)
        @saving_product = args.fetch(:saving_product)
      end

      def rate_divisor
        364.0
      end
    end
  end
end
