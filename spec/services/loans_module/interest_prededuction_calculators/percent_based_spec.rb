require 'rails_helper'

module LoansModule
  module InterestPredeductionCalculators
    describe PercentBased do
      it "calculate" do
        interest_prededuction = create(:interest_prededuction, calculation_type: 'percent_based', rate: 0.75)
        amount = described_class.new(interest_prededuction: interest_prededuction, amount: 12_000).calculate

        expect(amount).to eql 9_000
      end
    end
  end
end
