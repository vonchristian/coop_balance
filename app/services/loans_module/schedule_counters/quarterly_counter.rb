module LoansModule
  module ScheduleCounters
    class QuarterlyCounter
      NUMBER_OF_MONTHS_PER_QUARTER = 3
      attr_reader :loan_application

      def initialize(args)
        @loan_application = args.fetch(:loan_application)
      end
      def schedule_count
        loan_application.term / NUMBER_OF_MONTHS_PER_QUARTER
      end
    end
  end
end
