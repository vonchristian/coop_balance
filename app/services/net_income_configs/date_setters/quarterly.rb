module NetIncomeConfigs
  module DateSetters
    class Quarterly
      attr_reader :net_income_config, :date

      def initialize(net_income_config:, date:)
        @net_income_config = net_income_config
        @date              = date
      end

      def beginning_date
        date.beginning_of_quarter.beginning_of_day
      end

      def ending_date
        date.end_of_quarter.end_of_day
      end
    end
  end
end
