module SavingsModule
  module InterestRateSetters
    class Daily
      attr_reader :saving_product_interest_config

      def initialize(saving_product_interest_config:)
        @saving_product_interest_config = saving_product_interest_config
      end

      def applicable_rate
        saving_product_interest_config.annual_rate / 365
      end
    end
  end
end