module LoansModule
  module ScheduleCounters
    class DailyCounter
      NUMBER_OF_DAYS_PER_MONTH = 30
      attr_reader :loan_application

      def initialize(args)
        @loan_application = args.fetch(:loan_application)
      end
      
      def schedule_count
        loan_application.term * NUMBER_OF_DAYS_PER_MONTH
      end
    end
  end
end
