require 'rails_helper'

module LoansModule
  module LoanProducts
    describe Charge do
      describe 'associations' do
        it { should belong_to :account }
        it { should belong_to :loan_product }
      end

      describe 'validations' do
        it { should validate_presence_of :name }
        it { should validate_presence_of :rate }
        it { should validate_presence_of :amount }
        it { should validate_numericality_of :rate }
        it { should validate_numericality_of :amount }
      end

      describe '#charge_amount(chargeable_amount:)' do
        let!(:percent_based) { create(:loan_product_charge, rate: 0.02, charge_type: 'percent_based') }
        let!(:amount_based) { create(:loan_product_charge, amount: 10, charge_type: 'amount_based') }

        it { expect(amount_based.charge_amount).to eq 10 }
        it { expect(percent_based.charge_amount(chargeable_amount: 100)).to eq 2.0 }
      end
    end
  end
end
