require 'rails_helper'

module Vouchers
  describe AmountAdjustment do
    describe 'associations' do
      it { is_expected.to belong_to :loan_application }
      it { is_expected.to have_many :voucher_amounts }
    end
  end
  context 'adjusted_amount(voucher_amount)' do
    it 'amount_based' do
      voucher_amount = create(:voucher_amount, amount: 1_000)
      amount_adjustment = create(:amount_adjustment, amount: 100, adjustment_type: 'amount_based')

      expect(amount_adjustment.adjusted_amount(voucher_amount: voucher_amount)).to eql 900
    end
    it 'percentage_based' do
      voucher_amount = create(:voucher_amount, amount: 1_000)
      amount_adjustment = create(:amount_adjustment, adjustment_type: 'percentage_based', rate: 0.10)
      expect(amount_adjustment.adjusted_amount(voucher_amount: voucher_amount)).to eql 100
    end
  end

  # context 'adjusted_amount(loan_application)' do
  #   it 'number_of_payments_based' do
  #     loan_application = create(:loan_application)
  #   end
  # end


end
