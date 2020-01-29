module LoansModule
  module Amortizers
    module StraightLines
      class EqualPayment
        attr_reader :loan_product, :loan_application, :amortizer, :repayment_calculator

        def initialize(args={})
          @loan_application = args.fetch(:loan_application)
          @loan_product     = @loan_application.loan_product
          @amortizer        = @loan_product.amortizer
          @repayment_calculator = @loan_product.amortization_type.repayment_calculator
        end

        def create_schedule!
          create_first_schedule
          create_succeeding_schedule
          update_interests_and_ending_balances
          update_principals
        end

        private
        def create_first_schedule
          loan_application.amortization_schedules.create!(
            office:          loan_application.office,
            date:            loan_application.first_amortization_date,
            interest:        first_interest,
            principal:       first_principal,
            total_repayment: total_repayment,
            ending_balance:  loan_application.loan_amount.amount - first_principal
          )
        end

        def create_succeeding_schedule
          if loan_application.schedule_count > 1
            (loan_application.schedule_count - 1).to_i.times do
              loan_application.amortization_schedules.create!(
                office:          loan_application.office,
                date:            loan_application.succeeding_amortization_date,
                interest:        0,
                principal:       0,
                total_repayment: total_repayment
              )
            end
          end
        end

        def update_interests_and_ending_balances
          loan_application.amortization_schedules.by_oldest_date.each do |schedule|
            schedule.interest  = computed_interest_for(schedule)
            schedule.principal = computed_principal_for(schedule)

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
          ending_balance_for(schedule) * loan_product.current_interest_config.monthly_interest_rate
        end

        def computed_principal_for(schedule)
          schedule.total_repayment - computed_interest_for(schedule)
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
