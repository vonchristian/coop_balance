module LoansModule
  module Amortizers
    module DecliningBalances
      class EqualPrincipal
        attr_reader :loan_application, :loan_product, :interest_amortization_schedules

        def initialize(loan_application:)
          @loan_application       = loan_application
          @loan_product           = @loan_application.loan_product
          @amortization_schedules = @loan_application.amortization_schedules
        end

        def create_schedule!
          create_first_schedule
          create_succeeding_schedule
          update_interest_amounts
          update_total_repayments
        end

        private

        def update_total_repayments
          loan_application.amortization_schedules.each do |amortization_schedule|
            amortization_schedule.update(total_repayment: amortization_schedule.principal + amortization_schedule.interest)
          end
        end

        def update_interest_amounts
          set_first_year_interests
          case loan_application.schedule_count
          when 12..24
            set_second_year_interests
          when 25..36
            set_second_year_interests
            set_third_year_interests
          when 37..48
            set_second_year_interests
            set_third_year_interests
            set_fourth_year_interests
          when 49..60
            set_second_year_interests
            set_third_year_interests
            set_fourth_year_interests
            set_fifth_year_interests

          end
        end

        def update_total_repayments!
          loan_application.amortization_schedules.each do |schedule|
            schedule.total_repayment = schedule.principal + schedule.interest
            schedule.save!
          end
        end

        def create_first_schedule
          loan_application.amortization_schedules.create!(
            office: loan_application.office,
            date: loan_application.first_amortization_date,
            interest: 0,
            principal: loan_application.amortizeable_principal,
            ending_balance: loan_application.loan_amount.amount - loan_application.amortizeable_principal
          )
        end

        def create_succeeding_schedule
          return unless loan_application.schedule_count > 1

          (loan_application.schedule_count - 1).to_i.times do
            loan_application.amortization_schedules.create!(
              office: loan_application.office,
              date: loan_application.succeeding_amortization_date,
              interest: 0,
              principal: loan_application.amortizeable_principal,
              ending_balance: computed_ending_balance_for(loan_application.amortization_schedules.latest)
            )
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

        def set_first_year_interests
          loan_application.amortization_schedules.by_oldest_date.first(12).each do |schedule|
            schedule.update!(interest: loan_application.first_year_interest / 12.0)
          end
        end

        def set_second_year_interests
          loan_application.amortization_schedules.by_oldest_date.first(24).last(12).each do |schedule|
            schedule.update(interest: loan_application.second_year_interest / 12.0)
            schedule.save!
          end
        end

        def set_third_year_interests
          loan_application.amortization_schedules.by_oldest_date.first(36).last(12).each do |schedule|
            schedule.update(interest: loan_application.third_year_interest / 12.0)
            schedule.save!
          end
        end

        def set_fourth_year_interests
          loan_application.amortization_schedules.by_oldest_date.first(48).last(12).each do |schedule|
            schedule.update(interest: loan_application.fourth_year_interest / 12.0)
            schedule.save!
          end
        end

        def set_fifth_year_interests
          loan_application.amortization_schedules.by_oldest_date.first(60).last(12).each do |schedule|
            schedule.update(interest: loan_application.fifth_year_interest / 12.0)
            schedule.save!
          end
        end
      end
    end
  end
end
