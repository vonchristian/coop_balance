require 'rails_helper'

module LoansModule
  module Amortizers
    module StraightLines
      describe EqualPrincipal do
        it "#create_schedule" do
          amortization_type     = create(:amortization_type, calculation_type: 'straight_line', repayment_calculation_type: 'equal_principal')
          loan_product          = create(:loan_product, amortization_type: amortization_type)
          interest_config       = create(:interest_config, calculation_type: 'prededucted', rate: 0.12, loan_product: loan_product)
          interest_prededuction = create(:interest_prededuction, rate: 1, calculation_type: 'percent_based', loan_product: loan_product)
          loan_application      = create(:loan_application, loan_product: loan_product, mode_of_payment: 'monthly', term: 24, loan_amount: 150_000)

          described_class.new(loan_application: loan_application).create_schedule!
          described_class.new(loan_application: loan_application).update_interest_amounts!
          described_class.new(loan_application: loan_application).update_total_repayments!

          expect(loan_application.amortization_schedules.count).to eq loan_application.schedule_count
          puts loan_application.amortization_schedules.sum(&:interest).to_f
          puts loan_application.amortization_schedules.sum(&:total_repayment).to_f

        end
      end
    end
  end
end
