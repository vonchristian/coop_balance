module LoansModule
  module ScheduleCounters
    class LumpsumCounter
      attr_reader :loan_application

      def initialize(loan_application:)
        @loan_application = loan_application
      end

      def schedule_count
        1
      end
    end
  end
end
