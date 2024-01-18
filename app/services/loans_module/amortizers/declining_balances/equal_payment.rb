module LoansModule
  module Amortizers
    module DecliningBalances
      class EqualPayment
        attr_reader :loan_product, :loan_application, :amortizer

        def initialize(loan_application:)
          @loan_application = loan_application
          @loan_product     = @loan_application.loan_product
          @amortizer        = @loan_product.amortizer
        end

        def create_schedule!
          create_first_schedule
          create_succeeding_schedule
        end

        private

        def create_first_schedule
          loan_application.amortization_schedules.create!(
            office: loan_application.office,
            date: loan_application.first_amortization_date,
            interest: first_interest,
            principal: first_principal,
            total_amount: total_repayment,
            ending_balance: loan_application.loan_amount.amount - first_principal
          )
        end

        def create_succeeding_schedule
          return unless loan_application.schedule_count > 1

          (loan_application.schedule_count - 1).to_i.times do
            loan_application.amortization_schedules.create!(
              office: loan_application.office,
              date: loan_application.succeeding_amortization_date,
              interest: computed_interest_for(loan_application.amortization_schedules.latest),
              principal: computed_principal_for(loan_application.amortization_schedules.latest),
              total_amount: total_repayment,
              ending_balance: computed_ending_balance_for(loan_application.amortization_schedules.latest)
            )
          end
        end

        def amortizeable_interest_for(schedule)
          loan_application.loan_product.interest_calculator.new(loan_application: loan_application, schedule: schedule).monthly_amortization_interest
        end

        def first_interest
          loan_application.loan_amount.amount * loan_product.current_interest_config.monthly_interest_rate
        end

        def total_repayment
          loan_product.amortization_type.repayment_calculator.new(loan_application: loan_application).total_repayment
        end

        def first_principal
          total_repayment - first_interest
        end

        def computed_interest_for(schedule)
          schedule.ending_balance * loan_product.current_interest_config.monthly_interest_rate
        end

        def computed_principal_for(schedule)
          schedule.total_amount - computed_interest_for(schedule)
        end

        def computed_ending_balance_for(schedule)
          schedule.ending_balance - computed_principal_for(schedule)
        end

        def ending_balance_for(schedule)
          loan_application.amortization_schedules.find(schedule.id).ending_balance
        end
      end
    end
  end
end
