require 'rails_helper'

module LoansModule
  module InterestAmortizers
    describe StraightLine do
      it 'amortized_interest' do
        amortization_type            = create(:amortization_type, calculation_type: 'straight_line')
        interest_amortization        = create(:straight_line_interest_amortization)
        total_repayment_amortization = create(:total_repayment_amortization, calculation_type: 'equal_principal')
        loan_product                 = create(:loan_product, amortization_type: amortization_type, interest_amortization: interest_amortization, total_repayment_amortization: total_repayment_amortization)
        create(:interest_config, rate: 0.12, calculation_type: 'prededucted', loan_product: loan_product)
        create(:interest_prededuction, number_of_payments: 12, calculation_type: 'number_of_payments_based', loan_product: loan_product)
        loan_application_1           = create(:loan_application, loan_amount: 150_000, number_of_days: 1825, loan_product: loan_product, mode_of_payment: 'monthly')
        loan_application_2           = create(:loan_application, loan_amount: 10_000, number_of_days: 30, loan_product: loan_product, mode_of_payment: 'lumpsum')

        loan_product.amortizer.new(loan_application: loan_application_1).create_schedule!
        loan_product.amortizer.new(loan_application: loan_application_2).create_schedule!

        loan_application_1.amortization_schedules.order(date: :asc).each do |schedule|
          puts "#{schedule.date.strftime('%B %e, %Y')} | #{schedule.principal} | #{schedule.interest} | #{schedule.total_repayment}"
        end
        puts ''

        loan_application_2.amortization_schedules.order(date: :asc).each do |schedule|
          puts "#{schedule.date.strftime('%B %e, %Y')} | #{schedule.principal} | #{schedule.interest} | #{schedule.total_repayment}"
        end
      end
    end
  end
end