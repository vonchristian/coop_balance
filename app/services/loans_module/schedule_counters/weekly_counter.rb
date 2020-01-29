module LoansModule
  module ScheduleCounters
    class WeeklyCounter
      NUMBER_OF_WEEKS_PER_MONTH = 4

      attr_reader :loan_application

      def initialize(loan_application:)
        @loan_application = loan_application
      end
      
      def schedule_count
        loan_application.number_of_days * NUMBER_OF_WEEKS_PER_MONTH
      end
    end
  end
end
