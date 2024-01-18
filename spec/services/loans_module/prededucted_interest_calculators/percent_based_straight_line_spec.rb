require 'rails_helper'

module LoansModule
  module PredeductedInterestCalculators
    describe PercentBasedStraightLine do
      it '#prededucted_interest' do
        amortization_type     = create(:amortization_type, calculation_type: 'straight_line')
        loan_product          = create(:loan_product, amortization_type: amortization_type)
        create(:interest_prededuction, loan_product: loan_product, rate: 0.75, calculation_type: 'percent_based', prededuction_scope: 'on_first_year')
        create(:interest_config, rate: 0.12, loan_product: loan_product, calculation_type: 'prededucted')
        loan_application = create(:loan_application, loan_product: loan_product, loan_amount: 100_000, number_of_days: 365, mode_of_payment: 'monthly')

        loan_product.amortizer.new(loan_application: loan_application).create_schedule!

        expect(described_class.new(loan_application: loan_application).prededucted_interest).to be 9_000.00
      end
    end
  end
end
