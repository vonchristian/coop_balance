require 'rails_helper'

module LoansModule
  module LoanProductChargeCalculators
    describe AmountBased do
      it '#calculate' do
        amount_based = create(:loan_product_charge, amount: 100, charge_type: 'amount_based')

        expect(described_class.new(charge: amount_based).calculate).to be 100
      end
    end
  end
end
