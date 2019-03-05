require 'rails_helper'

module LoansModule
  module InterestPredeductionCalculators
    describe PercentBased do
      describe "calculate" do
        it "returns the total interest when term <= 12" do
          amortization_type     = create(:amortization_type, calculation_type: 'straight_line')
          loan_product          = create(:loan_product, amortization_type: amortization_type)
          interest_prededuction = create(:interest_prededuction, rate: 0.75, loan_product: loan_product)
          loan_application      = create(:loan_application, term: 6, loan_amount: 20_000,  loan_product: loan_product)

          amount = described_class.new(loan_application: loan_application, interest_prededuction: interest_prededuction).calculate

          expect(amount).to eql 1_200
        end

        it 'returns the total_interest * prededucted_rate when term > 12' do
          amortization_type     = create(:amortization_type,  calculation_type: 'straight_line')
          loan_product          = create(:loan_product, amortization_type: amortization_type)
          interest_prededuction = create(:interest_prededuction, rate: 0.75, loan_product: loan_product)
          loan_application      = create(:loan_application, term: 6, loan_amount: 20_000,  loan_product: loan_product)

          amount                = described_class.new(interest_prededuction: interest_prededuction, loan_application: loan_application).calculate

          expect(amount).to eql 1200
        end
      end
    end
  end
end
