module LoansModule
  module Amortizers
    module StraightLines
      class EqualPrincipal
        attr_reader :loan_application, :loan_product
        def initialize(args)
          @loan_application = args.fetch(:loan_application)
          @loan_product     = @loan_application.loan_product
        end

        def create_schedule!
          create_first_schedule
          create_succeeding_schedule
          #set_proper_dates
        end

        def update_interest_amounts!
          loan_application.amortization_schedules.each do |schedule|
            schedule.interest = amortizeable_interest_for(schedule)
            schedule.save!
          end
        end

        def update_total_repayments!
          loan_application.amortization_schedules.each do |schedule|
            schedule.total_repayment = schedule.principal + schedule.interest
            schedule.save!
          end
        end

        private

        def create_first_schedule
          loan_application.amortization_schedules.create!(
            cooperative:    loan_application.cooperative,
            office:         loan_application.office,
            date:           loan_application.first_amortization_date,
            interest:       0,
            principal:      loan_application.amortizeable_principal,
            ending_balance: loan_application.loan_amount.amount - loan_application.amortizeable_principal
          )
        end

        def create_succeeding_schedule
          if loan_application.schedule_count > 1
            (loan_application.schedule_count - 1).to_i.times do
              loan_application.amortization_schedules.create!(
                cooperative:    loan_application.cooperative,
                office:         loan_application.office,
                date:           loan_application.succeeding_amortization_date,
                interest:       0,
                principal:      loan_application.amortizeable_principal,
                ending_balance: computed_ending_balance_for(loan_application.amortization_schedules.latest)
              )
            end
          end
        end

        def computed_ending_balance_for(schedule)
          ending_balance_for(schedule) - schedule.principal
        end

        def ending_balance_for(schedule)
          loan_application.amortization_schedules.find(schedule.id).ending_balance
        end

        def amortizeable_interest_for(schedule)
          loan_product.interest_calculator.new(
            loan_application: loan_application, 
            schedule: schedule
          ).monthly_amortization_interest
        end
      end
    end
  end
end
