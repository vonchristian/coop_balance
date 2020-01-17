module SavingsModule
  module DateSetters
    class Annually
      attr_reader :saving_product_interest_config, :date

      def initialize(saving_product_interest_config:, date:)
        @saving_product_interest_config = saving_product_interest_config
        @date                           = date
      end

      def beginning_date
        date.beginning_of_year
      end

      def ending_date
        date.end_of_year
      end
    end
  end
end
