module LoansModule
  module ScheduleCounters
    class MonthlyCounter
      

      attr_reader :loan_application

      def initialize(loan_application:)
        @loan_application = loan_application
      end

      def schedule_count
        loan_application.number_of_days / DayCount::NUMBER_OF_DAYS_PER_MONTH
      end
    end
  end
end
