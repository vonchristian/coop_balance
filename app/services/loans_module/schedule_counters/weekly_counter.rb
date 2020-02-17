module LoansModule
  module ScheduleCounters
    class WeeklyCounter
      NUMBER_OF_DAYS_PER_WEEK = 7

      attr_reader :loan_application

      def initialize(loan_application:)
        @loan_application = loan_application
      end
      
      def schedule_count
        loan_application.number_of_days / NUMBER_OF_DAYS_PER_WEEK
      end
    end
  end
end
