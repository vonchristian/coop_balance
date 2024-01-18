require 'rails_helper'

module LoansModule
  module InterestPredeductionCalculators
    describe NumberOfPaymentsBased do
      it 'calculate' do
        amortization_type     = create(:amortization_type, calculation_type: 'declining_balance')
        loan_product          = create(:loan_product, amortization_type: amortization_type)
        create(:interest_config, calculation_type: 'prededucted', rate: 0.12, loan_product: loan_product)
        create(:interest_prededuction, calculation_type: 'number_of_payments_based', number_of_payments: 3, loan_product: loan_product)
        loan_application = create(:loan_application, loan_amount: 150_000, application_date: Date.current, mode_of_payment: 'monthly', term: 12, loan_product: loan_product)
        amortization_type.amortizer.new(loan_application: loan_application).create_schedule!
        amount = described_class.new(loan_application: loan_application).calculate

        expect(amount).to be 4125
      end
    end
  end
end
