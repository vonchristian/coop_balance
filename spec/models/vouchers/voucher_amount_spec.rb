require 'rails_helper'

module Vouchers
  describe VoucherAmount do
    describe 'associations' do
      it { is_expected.to belong_to :account }
      it { is_expected.to belong_to :voucher }
      it { is_expected.to belong_to :commercial_document }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :amount }
      it { is_expected.to validate_presence_of :account_id }
      it { is_expected.to validate_presence_of :amount_type }
      it { is_expected.to validate_numericality_of :amount }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
    end
    it ".total" do
      voucher_amount = create(:voucher_amount, amount: 100)
      another_voucher_amount = create(:voucher_amount, amount: 100)

      expect(described_class.total).to eql 200
    end
  end
end
