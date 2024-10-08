module LoansModule
  module ScheduleFinders
    module SecondYear
      class Quarterly
        attr_reader :loan_application

        def initialize(args)
          @loan_application = args.fetch(:loan_application)
        end

        def find_schedule
          loan_application.amortization_schedules.by_oldest_date[3]
        end
      end
    end
  end
end
