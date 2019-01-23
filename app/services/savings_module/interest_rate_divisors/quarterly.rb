module SavingsModule
  module InterestRateDivisors
    class Quarterly
      attr_reader :saving_product

      def initialize(args)
        @saving_product = args.fetch(:saving_product)
      end

      def rate_divisor
        4.0
      end
    end
  end
end
