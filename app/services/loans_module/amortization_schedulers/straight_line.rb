module LoansModule
  module AmortizationSchedulers
    class StraightLine
      attr_reader :loan_application

      def initialize(args)
        @loan_application = args.fetch(:loan_application)
      end

      def create_schedule
        create_first_schedule
        create_succeeding_schedule
        update_interests
        # set_proper_dates
      end

      def create_first_schedule
        amortization_schedules.create(
          date:      loan_application.first_amortization_date,
          interest:  0,
          principal: loan_application.amortizeable_principal
        )
      end

      def create_succeeding_schedule
        amortization_schedules.create(
          date:      loan_application.succeeding_amortization_date,
          interest:  0,
          principal: loan_application.amortizeable_principal
        )
      end

      def update_interests
        loan_application.amortization_schedules.each do |schedule|
          schedule.interest = loan_application.amortizeable_interest
          schedule.save!
        end
      end
    end
  end
end
