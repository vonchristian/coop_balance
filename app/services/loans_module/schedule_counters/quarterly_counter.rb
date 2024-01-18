module LoansModule
  module ScheduleCounters
    class QuarterlyCounter
      NUMBER_OF_MONTHS_PER_QUARTER = 3

      attr_reader :loan_application

      def initialize(loan_application:)
        @loan_application = loan_application
      end

      def schedule_count
        (loan_application.number_of_days / DayCount::NUMBER_OF_DAYS_PER_MONTH) / NUMBER_OF_MONTHS_PER_QUARTER
      end
    end
  end
end
