require 'rails_helper'

module LoansModule
  module LoanProductChargeCalculators
    describe PercentBased do
      it "#calculate" do
        percent_based = create(:loan_product_charge, rate: 0.03, charge_type: 'percent_based')

        expect(described_class.new(charge: percent_based, chargeable_amount: 100_000).calculate).to eql 3_000
      end
    end
  end
end
