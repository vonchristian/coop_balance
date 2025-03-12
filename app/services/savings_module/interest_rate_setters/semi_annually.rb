module SavingsModule
  module InterestRateSetters
    class SemiAnnually
      attr_reader :saving_product_interest_config

      def initialize(saving_product_interest_config:)
        @saving_product_interest_config = saving_product_interest_config
      end

      def applicable_rate
        saving_product_interest_config.annual_rate / 2
      end
    end
  end
end
