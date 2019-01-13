module LoansModule
  module AmortizationSchedulers
    class NumberOfPaymentsDecliningBalance
      attr_reader :scheduleable, :number_of_payments
      def initialize(args)
        @scheduleable = args.fetch(:scheduleable)
        @loan_product = @scheduleable.loan_product
        @number_of_payments = @loan_product.current_interest_prededuction_number_of_payments

      end
      def create_schedule!
        create_first_schedule
        create_succeeding_schedule
        update_interest_amounts
        update_interests_status
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
        (scheduleable.schedule_count - 1).to_i.times do
          scheduleable.amortization_schedules.create!(
            date:      scheduleable.succeeding_amortization_date,
            interest:  0,
            principal: scheduleable.amortizeable_principal
          )
        end
      end

      def update_interest_amounts
        scheduleable.amortization_schedules.each do |schedule|
          schedule.interest = amortizeable_interest_for(schedule)
          schedule.save!
        end
      end

      def update_interests_status
          scheduleable.amortization_schedules.by_oldest_date.first(number_of_payments).each do |schedule|
          schedule.prededucted_interest = true
          schedule.save!
        end
      end

      def amortizeable_interest_for(schedule)
        scheduleable.loan_product.interest_calculator.new(loan_application: scheduleable, schedule: schedule).monthly_amortization_interest
      end
    end
  end
end
