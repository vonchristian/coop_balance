require 'rails_helper'

module LoansModule
  module Amortizers
    describe StraightLine do
      it "create_first_schedule" do
        amortization_type     = create(:amortization_type, calculation_type: 'straight_line')
        loan_product          = create(:loan_product, amortization_type: amortization_type)
        interest_config       = create(:interest_config, calculation_type: 'prededucted', rate: 0.15, loan_product: loan_product)
        interest_prededuction = create(:interest_prededuction, calculation_type: 'percent_based', rate: 0.75, loan_product: loan_product)
        loan_application      = create(:loan_application, loan_amount: 150_000, mode_of_payment: 'monthly', term: 12, loan_product: loan_product)

        described_class.new(loan_application: loan_application).create_schedule!
        described_class.new(loan_application: loan_application).update_interest_amounts!

        puts loan_application.amortization_schedules.by_oldest_date.map { |schedule| [schedule.date.strftime("%B %e, %Y"), schedule.principal, schedule.interest, schedule.total_amortization, loan_application.principal_balance_for(schedule)] }

      end
    end
  end
end
