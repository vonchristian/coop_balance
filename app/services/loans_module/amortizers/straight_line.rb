module LoansModule
  module Amortizers
    class StraightLine
      attr_reader :loan_application, :loan_product
      def initialize(args)
        @loan_application = args.fetch(:loan_application)
        @loan_product     = @loan_application.loan_product
      end

      def create_schedule!
        create_first_schedule
        create_succeeding_schedule
      end

      def update_interest_amounts!
        loan_application.amortization_schedules.each do |schedule|
          schedule.interest = amortizeable_interest_for(schedule)
          schedule.save!
        end
      end
      private

      def create_first_schedule
        loan_application.amortization_schedules.create!(
          date:      loan_application.first_amortization_date,
          interest:  0,
          principal: loan_application.amortizeable_principal
        )
      end

      def create_succeeding_schedule
        if !loan_application.lumpsum?
          (loan_application.schedule_count - 1).to_i.times do
            loan_application.amortization_schedules.create!(
              date:      loan_application.succeeding_amortization_date,
              interest:  0,
              principal: loan_application.amortizeable_principal
            )
          end
        end
      end

      def amortizeable_interest_for(schedule)
        loan_product.interest_calculator.new(loan_application: loan_application, schedule: schedule).monthly_amortization_interest
      end
    end
  end
end
