module SavingsModule
  module InterestRateDivisors
    class SemiAnnually
      attr_reader :saving_product

      def initialize(args)
        @saving_product = args.fetch(:saving_product)
      end

      def rate_divisor
        2.0
      end
    end
  end
end
