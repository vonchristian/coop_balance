require 'rails_helper'

module LoansModule
  module InterestCalculators
    describe NumberOfPaymentsDecliningBalance do
      it "#compute" do
        amortization_type     = create(:amortization_type, calculation_type: 'declining_balance')
        loan_product          = create(:loan_product, amortization_type: amortization_type)
        interest_prededuction = create(:interest_prededuction, loan_product: loan_product, number_of_payments: 3, calculation_type: 'number_of_payments')
        interest_config       = create(:interest_config, rate: 0.12, loan_product: loan_product, calculation_type: 'prededucted')
        loan_application      = create(:loan_application, loan_product: loan_product, loan_amount: 100_000, term: 12, mode_of_payment: 'monthly')

        LoansModule::AmortizationScheduler.new(scheduleable: loan_application).create_schedule!
        puts loan_application.amortization_schedules.by_oldest_date.first.inspect
      end
    end
  end
end
