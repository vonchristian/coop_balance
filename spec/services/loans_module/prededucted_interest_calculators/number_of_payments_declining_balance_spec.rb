require 'rails_helper'

module LoansModule
  module PredeductedInterestCalculators
    describe NumberOfPaymentsDecliningBalance do
      it "prededucted_interest" do
        amortization_type     = create(:amortization_type, calculation_type: 'declining_balance')
        loan_product          = create(:loan_product, amortization_type: amortization_type)
        interest_prededuction = create(:interest_prededuction, loan_product: loan_product, number_of_payments: 3, calculation_type: 'number_of_payments_based')
        interest_config       = create(:interest_config, rate: 0.12, loan_product: loan_product, calculation_type: 'prededucted')
        loan_application      = create(:loan_application, loan_product: loan_product, loan_amount: 100_000, term: 12, mode_of_payment: 'monthly')

        loan_product.amortizer.new(loan_application: loan_application).create_schedule!
        puts loan_application.amortization_schedules.by_oldest_date.map{ |schedule| schedule.interest }

        prededucted_interest = ((described_class.new(loan_application: loan_application).prededucted_interest))

        expect(prededucted_interest).to eql 2_750.00
      end
    end
  end
end
