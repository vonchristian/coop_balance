require 'rails_helper'

module Vouchers
  describe AmountAdjustment do

    describe 'associations' do
      it { is_expected.to belong_to :loan_application }
      it { is_expected.to belong_to :voucher_amount }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :voucher_amount_id}
    end

    it '.recent' do
      old_adjustment = create(:amount_adjustment, created_at: Date.today.yesterday)
      recent_adjustment = create(:amount_adjustment, created_at: Date.today)

      expect(described_class.recent).to eql recent_adjustment
      expect(described_class.recent).to_not eql old_adjustment
    end

    describe 'adjusted_amount(voucher_amount)' do
      it 'amount_based' do
        voucher_amount    = create(:voucher_amount, amount: 1_000)
        amount_adjustment = voucher_amount.amount_adjustments.create(amount: 100, adjustment_type: 'amount_based')

        expect(amount_adjustment.adjusted_amount(adjustable: voucher_amount)).to eql 900
      end

      it 'percentage_based' do
        voucher_amount    = create(:voucher_amount, amount: 1_000)
        amount_adjustment = voucher_amount.amount_adjustments.create(adjustment_type: 'percentage_based', rate: 0.10)
        expect(amount_adjustment.adjusted_amount(adjustable: voucher_amount)).to eql 100
      end
    end
  end
end
