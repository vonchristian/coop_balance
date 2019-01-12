module LoansModule
  module ScheduleCounters
    class MonthlyCounter
      attr_reader :loan_application

      def initialize(args)
        @loan_application = args.fetch(:loan_application)
      end

      def schedule_count
        loan_application.term
      end
    end
  end
end
