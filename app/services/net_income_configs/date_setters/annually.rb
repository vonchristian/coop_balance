module NetIncomeConfigs
  module DateSetters
    class Annually
      attr_reader :net_income_config, :date

      def initialize(net_income_config:, date:)
        @net_income_config = net_income_config
        @date              = date
      end

      def beginning_date
        date.beginning_of_year.beginning_of_day
      end

      def ending_date
        date.end_of_year.end_of_day
      end
    end
  end
end