require 'rails_helper'

module LoansModule
  describe ChargeAdjustment do
    describe 'associations' do
      it { is_expected.to belong_to :loan_charge }
    end

    it '#charge_amount' do
      charge = create(:charge, amount: 100, charge_type: 'amount_type')
      loan_charge = create(:loan_charge, chargeable: charge)
      amount_charge_adjustment = create(:charge_adjustment, loan_charge: loan_charge, amount: 50)

      percent_charge_adjustment = create(:charge_adjustment, percent: 15, loan_charge: loan_charge, amount: nil)

      expect(amount_charge_adjustment.adjusted_charge_amount).to eql(50)
      expect(percent_charge_adjustment.adjusted_charge_amount).to eql(15)
    end
  end
end
