module LoansModule
  module ScheduleFinders
    module SecondYear
      class Daily
        attr_reader :loan_application

        def initialize(args)
          @loan_application = args.fetch(:loan_application)
        end

        def find_schedule
          schedule = loan_application.amortization_schedules.by_oldest_date[359]
        end
      end
    end
  end
end
