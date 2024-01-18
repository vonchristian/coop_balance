module NetIncomeConfigs
  module DateSetters
    class SemiAnnually
      attr_reader :net_income_config, :date

      def initialize(net_income_config:, date:)
        @net_income_config = net_income_config
        @date              = date
      end

      def beginning_date
        if date_is_within_first_part_of_year?
          date.beginning_of_year
        else
          (date.beginning_of_year + 6.months).beginning_of_month
        end
      end

      def ending_date
        if date_is_within_first_part_of_year?
          date.beginning_of_year.next_quarter.end_of_quarter
        else
          date.end_of_year
        end
      end

      private

      def date_is_within_first_part_of_year?
        (date.beginning_of_quarter..(date.beginning_of_year.next_quarter.end_of_quarter)).cover?(date)
      end
    end
  end
end