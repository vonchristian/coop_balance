require 'rails_helper'

module LoansModule
  module Amortizers
    module StraightLines
      describe EqualPrincipal do
        it '#create_schedule' do
          amortization_type     = create(:amortization_type, calculation_type: 'straight_line', repayment_calculation_type: 'equal_principal')
          loan_product          = create(:loan_product, amortization_type: amortization_type)
          create(:interest_prededuction, loan_product: loan_product, number_of_payments: 3, calculation_type: 'number_of_payments_based')
          create(:interest_config, rate: 0.12, loan_product: loan_product, calculation_type: 'prededucted')
          loan_application = create(:loan_application, loan_product: loan_product, loan_amount: 300_000, number_of_days: 1825, mode_of_payment: 'monthly')

          loan_product.amortizer.new(loan_application: loan_application).create_schedule!
          puts "First Year Interest: #{loan_application.first_year_interest}"
          puts "Second Year Interest: #{loan_application.second_year_interest.to_f}"
          puts "Third Year Interest: #{loan_application.third_year_interest.to_f}"
          puts "Fourth Year Interest: #{loan_application.fourth_year_interest.to_f}"
          puts "Fifth Year Interest: #{loan_application.fifth_year_interest.to_f}"
          puts "Sixth Year Interest: #{loan_application.sixth_year_interest.to_f}"

          puts loan_application.first_year_principal_balance
          puts loan_application.second_year_principal_balance.to_f
          puts loan_application.third_year_principal_balance.to_f
          puts loan_application.fourth_year_principal_balance.to_f

          puts loan_application.second_year_interest
          puts loan_application.second_year_interest

          puts loan_application.schedule_count
          puts 'PRINCIPAL | INTEREST | TOTAL REPAYMENT'

          loan_application.amortization_schedules.by_oldest_date.each do |schedule|
            puts "#{schedule.principal.to_f} | #{schedule.interest.to_f} | #{schedule.total_repayment.to_f}"
          end
        end
      end
    end
  end
end
