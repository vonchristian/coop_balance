module LoansModule
  module ScheduleFinders
    module SecondYear
      class Weekly
        attr_reader :loan_application

        def initialize(args)
          @loan_application = args.fetch(:loan_application)
        end

        def find_schedule
          schedule = amortization_schedules.by_oldest_date[47]
        end
      end
    end
  end
end
