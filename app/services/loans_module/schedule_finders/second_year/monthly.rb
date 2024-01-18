module LoansModule
  module ScheduleFinders
    module SecondYear
      class Monthly
        attr_reader :loan_application, :amortization_schedules

        def initialize(args)
          @loan_application = args.fetch(:loan_application)
          @amortization_schedules = @loan_application.amortization_schedules
        end

        def find_schedule
          amortization_schedules.by_oldest_date[11]
        end
      end
    end
  end
end
