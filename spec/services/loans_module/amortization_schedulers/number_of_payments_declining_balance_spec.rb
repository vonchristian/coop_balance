require 'rails_helper'

module LoansModule
  module AmortizationSchedulers
    describe NumberOfPaymentsDecliningBalance do
      it "#create_schedule!" do
        amortization_type     = create(:amortization_type, calculation_type: 'declining_balance')
        loan_product          = create(:loan_product, amortization_type: amortization_type)
        interest_prededuction = create(:interest_prededuction, loan_product: loan_product, rate: 0.75, calculation_type: 'percent_based')
        interest_config       = create(:interest_config, rate: 0.12, loan_product: loan_product, calculation_type: 'prededucted')
        loan_application      = create(:loan_application, loan_product: loan_product, loan_amount: 100_000, term: 12, mode_of_payment: 'monthly')

        described_class.new(scheduleable: loan_application).create_schedule!

        puts loan_application.amortization_schedules.by_oldest_date.map { |schedule| [schedule.date.strftime("%B %e, %Y"), schedule.principal, schedule.interest, schedule.total_amortization, loan_application.principal_balance_for(schedule)] }

      end
    end
  end
end
