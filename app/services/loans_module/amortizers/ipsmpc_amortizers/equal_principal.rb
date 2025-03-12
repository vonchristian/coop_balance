module LoansModule
  module Amortizers
    module IpsmpcAmortizers
      class EqualPrincipal
        attr_reader :loan_application, :loan_product, :interest_amortization_schedules

        def initialize(args)
          @loan_application                = args.fetch(:loan_application)
          @loan_product                    = @loan_application.loan_product
          @interest_amortization_schedules = @loan_application.amortization_schedules.order(:date).last(loan_application.schedule_count - 12)
        end

        def create_schedule!
          create_first_schedule
          create_succeeding_schedule
          # set_proper_dates
        end

        def update_interest_amounts!
          if loan_application.schedule_count > 12
            if interest_amortization_schedules.count <= 12
              set_second_year_interests
            elsif interest_amortization_schedules.count <= 24
              set_second_year_interests
              set_third_year_interests
            elsif interest_amortization_schedules.count <= 36
              set_second_year_interests
              set_third_year_interests
              set_fourth_year_interests
            elsif interest_amortization_schedules.count <= 48
              set_second_year_interests
              set_third_year_interests
              set_fourth_year_interests
              set_fifth_year_interests
            end
          else
            loan_application.amortization_schedules.each do |schedule|
              schedule.interest = amortizeable_interest_for(schedule)
              schedule.save!
            end
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

        def set_second_year_interests
          interest_amortization_schedules.first(12).each do |schedule|
            schedule.interest = loan_application.second_year_interest / interest_amortization_schedules.first(12).count
            schedule.save!
          end
        end

        def set_third_year_interests
          third_year_schedules = interest_amortization_schedules.first(24) - interest_amortization_schedules.first(12)
          third_year_schedules.each do |schedule|
            schedule.interest = loan_application.third_year_interest / third_year_schedules.count
            schedule.save!
          end
        end

        def set_fourth_year_interests
          fourth_year_schedules = interest_amortization_schedules.first(36) - interest_amortization_schedules.first(24)
          fourth_year_schedules.each do |schedule|
            schedule.interest = loan_application.fourth_year_interest / fourth_year_schedules.count
            schedule.save!
          end
        end

        def set_fifth_year_interests
          fifth_year_schedules = interest_amortization_schedules.first(48) - interest_amortization_schedules.first(36)
          fifth_year_schedules.each do |schedule|
            schedule.interest = loan_application.fifth_year_interest / fifth_year_schedules.count
            schedule.save!
          end
        end
      end
    end
  end
end
