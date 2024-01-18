module LoansModule
  module Amortizers
    class DecliningBalance
      attr_reader :loan_application, :number_of_payments, :interest_prededuction

      def initialize(args)
        @loan_application      = args.fetch(:loan_application)
        @loan_product          = @loan_application.loan_product
        @interest_prededuction = @loan_product.current_interest_prededuction
        @number_of_payments    = @interest_prededuction.number_of_payments
      end

      def create_schedule!
        create_first_schedule
        create_succeeding_schedule
        update_interest_amounts
        update_interests_status
      end

      private

      def create_first_schedule
        loan_application.amortization_schedules.create!(
          date: loan_application.first_amortization_date,
          interest: 0,
          principal: loan_application.amortizeable_principal
        )
      end

      def create_succeeding_schedule
        return if loan_application.lumpsum?

        (loan_application.schedule_count - 1).to_i.times do
          loan_application.amortization_schedules.create!(
            date: loan_application.succeeding_amortization_date,
            interest: 0,
            principal: loan_application.amortizeable_principal
          )
        end
      end

      def update_interest_amounts
        loan_application.amortization_schedules.each do |schedule|
          schedule.interest = amortizeable_interest_for(schedule)
          schedule.save!
        end
      end

      def update_interests_status
        return unless interest_prededuction.number_of_payments_based?

        loan_application.amortization_schedules.by_oldest_date.first(number_of_payments).each do |schedule|
          schedule.prededucted_interest = true
          schedule.save!
        end
      end

      def amortizeable_interest_for(schedule)
        loan_application.loan_product.interest_calculator.new(loan_application: loan_application, schedule: schedule).monthly_amortization_interest
      end
    end
  end
end
