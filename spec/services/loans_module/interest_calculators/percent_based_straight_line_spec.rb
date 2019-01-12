require 'rails_helper'

module LoansModule
  module InterestCalculators
    describe PercentBasedStraightLine do
      it '#compute' do
        amortization_type     = create(:amortization_type, calculation_type: 'straight_line')
        loan_product          = create(:loan_product, amortization_type: amortization_type)
        interest_prededuction = create(:interest_prededuction, loan_product: loan_product, rate: 0.75, calculation_type: 'percent_based')
        interest_config       = create(:interest_config, rate: 0.12, loan_product: loan_product, calculation_type: 'prededucted')
        loan_application      = create(:loan_application, loan_product: loan_product, loan_amount: 100_000, term: 12, mode_of_payment: 'monthly')

        amortization_type.scheduler.new(scheduleable: loan_application).create_schedule!

        expect(described_class.new(loan_application: loan_application).monthly_amortization_interest).to eql 250
      end
    end
  end
end
