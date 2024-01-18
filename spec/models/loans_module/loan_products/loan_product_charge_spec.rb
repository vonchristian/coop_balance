require 'rails_helper'

module LoansModule
  module LoanProducts
    describe LoanProductCharge do
      describe 'associations' do
        it { should belong_to :account }
        it { should belong_to :loan_product }
      end

      describe 'validations' do
        it { should validate_presence_of :name }
        it { should validate_presence_of :account_id }
        it { should validate_presence_of :rate }
        it { should validate_presence_of :amount }
        it { should validate_numericality_of :rate }
        it { should validate_numericality_of :amount }
      end

      it '#charge_calculator' do
        percent_based = create(:loan_product_charge, charge_type: 'percent_based')
        amount_based  = create(:loan_product_charge, charge_type: 'amount_based')

        expect(percent_based.charge_calculator).to eql LoansModule::LoanProductChargeCalculators::PercentBased
        expect(amount_based.charge_calculator).to eql LoansModule::LoanProductChargeCalculators::AmountBased
      end
    end
  end
end
