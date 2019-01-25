require 'rails_helper'

module LoansModule
  module Amortizers
    describe DecliningBalance do
      it "create_first_schedule" do
        amortization_type     = create(:amortization_type, calculation_type: 'declining_balance')
        loan_product          = create(:loan_product, amortization_type: amortization_type)
        interest_config       = create(:interest_config, calculation_type: 'prededucted', rate: 0.12, loan_product: loan_product)
        interest_prededuction = create(:interest_prededuction, calculation_type: 'number_of_payments_based', number_of_payments: 3, loan_product: loan_product)
        loan_application      = create(:loan_application, loan_amount: 150_000, mode_of_payment: 'monthly', term: 12, loan_product: loan_product)

        described_class.new(loan_application: loan_application).create_schedule!
        puts loan_application.amortization_schedules.by_oldest_date.map { |schedule| [schedule.date.strftime("%B %e, %Y"), schedule.principal, schedule.interest, schedule.total_amortization, loan_application.principal_balance_for(schedule)] }

      end
    end
  end
end
