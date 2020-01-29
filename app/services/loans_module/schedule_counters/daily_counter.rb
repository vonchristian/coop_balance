module LoansModule
  module ScheduleCounters
    class DailyCounter
      attr_reader :loan_application

      def initialize(loan_application:)
        @loan_application = loan_application
      end
      
      def schedule_count
        loan_application.number_of_days
      end
    end
  end
end
