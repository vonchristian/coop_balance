require 'rails_helper'

module Vouchers
  describe VoucherAmount do
    describe 'associations' do
      it { is_expected.to belong_to :account }
      it { is_expected.to belong_to :voucher }
      it { is_expected.to belong_to :commercial_document }
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to(:loan_application).optional }

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
      it '.with_cash_accounts' do
        cash_on_hand = create(:asset)
        revenue      = create(:revenue)
        liability    = create(:liability)
        employee     = create(:user)
        employee.cash_accounts << cash_on_hand

        cash_amount = create(:voucher_amount, account: cash_on_hand)
        non_cash_amount = create(:voucher_amount, account: revenue)

        expect(described_class.with_cash_accounts).to include(cash_amount)
        expect(described_class.with_cash_accounts).to_not include(non_cash_amount)
      end

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
    describe ".total" do
      it '.with no amount adjustment' do
        voucher_amount = create(:voucher_amount, amount: 100)
        another_voucher_amount = create(:voucher_amount, amount: 100)

        expect(described_class.total).to eql 200
      end

      it '.with amount adjustment' do
        voucher_amount = create(:voucher_amount, amount: 100)
        amount_adjustment = create(:amount_adjustment, voucher_amount: voucher_amount, adjustment_type: 'amount_based', amount: 20)

        expect(described_class.total).to eql 80
      end
    end
    it '#disbursed?' do
      cooperative = create(:cooperative)
      voucher  = create(:voucher, cooperative: cooperative)
      disbursed_amount = create(:voucher_amount, voucher: voucher, cooperative: cooperative)
      undisbursed_amount = create(:voucher_amount, cooperative: cooperative)
      entry = create(:entry_with_credit_and_debit, cooperative: cooperative)
      voucher.update_attributes(accounting_entry: entry)

      expect(disbursed_amount.disbursed?).to be true
      expect(undisbursed_amount.disbursed?).to be false
    end

  end
end
