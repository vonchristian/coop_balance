module LoansModule
  module Amortizers
    module StraightLines
      class EqualPrincipal
        attr_reader :loan_product, :loan_application

        def initialize(loan_application:)
          @loan_application     = loan_application
          @loan_product         = @loan_application.loan_product
        end

        def create_schedule!
          create_first_schedule
          create_succeeding_schedule
          update_interests
          update_prededucted_interests
          update_total_repayments
          update_ending_balances
        end

        private

        def create_first_schedule
          loan_application.amortization_schedules.create!(
            office: loan_application.office,
            date: loan_application.first_amortization_date,
            interest: first_interest,
            principal: loan_application.loan_amount.amount / loan_application.schedule_count
          )
        end

        def create_succeeding_schedule
          return unless loan_application.schedule_count > 1

          (loan_application.schedule_count - 1).to_i.times do
            loan_application.amortization_schedules.create!(
              office: loan_application.office,
              date: loan_application.succeeding_amortization_date,
              interest: 0,
              principal: loan_application.loan_amount.amount / loan_application.schedule_count
            )
          end
        end

        def update_interests
          loan_application.amortization_schedules.by_oldest_date.each do |schedule|
            schedule.interest = computed_interest_for(schedule)
            schedule.save!
          end
        end

        def update_total_repayments
          loan_application.amortization_schedules.by_oldest_date.each do |schedule|
            schedule.total_repayment = computed_total_repayment_for(schedule)
            schedule.save!
          end
        end

        def update_prededucted_interests
          loan_application.amortization_schedules.by_oldest_date.each do |schedule|
            LoansModule::PredeductedInterestUpdater.new(schedule: schedule).update_prededucted_interests!
          end
        end

        def update_ending_balances
          loan_application.amortization_schedules.by_oldest_date.each do |schedule|
            schedule.ending_balance = loan_application.principal_balance_for(schedule)
            schedule.save!
          end
        end

        def amortizeable_interest_for(schedule)
          loan_application.loan_product.interest_calculator.new(loan_application: loan_application, schedule: schedule).monthly_amortization_interest
        end

        def first_interest
          loan_application.loan_amount.amount * loan_product.current_interest_config.monthly_interest_rate
        end

        def total_repayment
          repayment_calculator.new(loan_application: loan_application).total_repayment
        end

        def first_principal
          total_repayment - first_interest
        end

        def computed_interest_for(schedule)
          loan_product.interest_amortizer.new(schedule: schedule).amortized_interest
        end

        def computed_total_repayment_for(schedule)
          loan_product.total_repayment_amortizer.new(schedule: schedule).amortized_total_repayment
        end

        def computed_ending_balance_for(schedule)
          ending_balance_for(schedule) - computed_principal_for(schedule)
        end

        def ending_balance_for(schedule)
          loan_application.amortization_schedules.find(schedule.previous_schedule).ending_balance
        end
      end
    end
  end
end
