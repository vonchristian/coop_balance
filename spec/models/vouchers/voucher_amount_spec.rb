require 'rails_helper'

module Vouchers
  describe VoucherAmount do
    describe 'associations' do
      it { is_expected.to belong_to :account }
      it { is_expected.to belong_to :voucher }
      it { is_expected.to belong_to :commercial_document }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :account_id }
      it { is_expected.to validate_presence_of :amount_type }
      it { is_expected.to monetize(:amount) }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
    end
    describe 'scopes' do
      it '.for_account(args={})' do
        revenue_account = create(:revenue)
        expense_account = create(:expense)
        revenue_amount = create(:voucher_amount, account: revenue_account)
        expense_amount = create(:voucher_amount, account: expense_account)

        expect(described_class.for_account(account: revenue_account)).to include(revenue_amount)
        expect(described_class.for_account(account: revenue_account)).to_not include(expense_amount)
      end
      it '.excluding_account(args={})' do
        revenue_account = create(:revenue)
        expense_account = create(:expense)
        revenue_amount = create(:voucher_amount, account: revenue_account)
        expense_amount = create(:voucher_amount, account: expense_account)

        expect(described_class.excluding_account(account: revenue_account)).to include(expense_amount)
        expect(described_class.excluding_account(account: revenue_account)).to_not include(revenue_amount)
      end
    end
    it ".total" do
      voucher_amount = create(:voucher_amount, amount: 100)
      another_voucher_amount = create(:voucher_amount, amount: 100)

      expect(described_class.total).to eql 200
    end
  end
end
