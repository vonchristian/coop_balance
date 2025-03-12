module Programs
  module DateSetters
    class Annually
      attr_reader :date

      def initialize(date:)
        @date = date
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
