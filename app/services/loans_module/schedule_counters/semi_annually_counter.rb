module LoansModule
  module ScheduleCounters
    class SemiAnnuallyCounter
      NUMBER_OF_MONTHS_PER_SEMI_ANNUAL = 6

      attr_reader :loan_application

      def initialize(args)
        @loan_application = args.fetch(:loan_application)
      end
      
      def schedule_count
        loan_application.term / NUMBER_OF_MONTHS_PER_SEMI_ANNUAL
      end
    end
  end
end
