module LoansModule
  module AmortizationSchedulers
    class AddOnStraightLine
      attr_reader :scheduleable, :loan_product

      def initialize(args)
        @scheduleable = args.fetch(:scheduleable)
        @loan_product = @scheduleable.loan_product
      end

      def create_schedule!
        create_first_schedule
        create_succeeding_schedule
        update_interests!
      end


      private
      def create_first_schedule
        scheduleable.amortization_schedules.create!(
          date:      scheduleable.first_amortization_date,
          interest:  0,
          principal: scheduleable.amortizeable_principal
        )
      end

      def create_succeeding_schedule
        if !scheduleable.lumpsum?
          (scheduleable.schedule_count - 1).floor.times do
            scheduleable.amortization_schedules.create!(
              date:      scheduleable.succeeding_amortization_date,
              interest:  0,
              principal: scheduleable.amortizeable_principal
            )
          end
        end
      end

      def update_interests!
        scheduleable.amortization_schedules.each do |schedule|
          schedule.interest = amortizeable_interest_for(schedule)
          schedule.save!
        end
      end

      def amortizeable_interest_for(schedule)
        loan_product.interest_calculator.new(loan_application: scheduleable).monthly_amortization_interest
      end
    end
  end
end
