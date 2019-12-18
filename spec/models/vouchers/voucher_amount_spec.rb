require 'rails_helper'

module Vouchers
  describe VoucherAmount do
    subject { build(:voucher_amount) }
    it { is_expected.to_not be_valid }

    describe 'associations' do
      it { is_expected.to belong_to :account }
      it { is_expected.to belong_to(:voucher).optional }
      it { is_expected.to belong_to(:cart).optional }
      it { is_expected.to belong_to(:commercial_document).optional }
      it { is_expected.to belong_to(:cooperative).optional }
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

    it ".total" do
      voucher_amount_1 = create(:voucher_amount, amount: 100)
      voucher_amount_2 = create(:voucher_amount, amount: 100)

      expect(described_class.total).to eql 200
    end

    it ".with_no_vouchers" do
      voucher = create(:voucher)
      voucher_amount_1 = create(:voucher_amount, amount: 100)
      voucher_amount_2 = create(:voucher_amount, amount: 100, voucher: voucher)

      expect(described_class.with_no_vouchers).to include(voucher_amount_1)
      expect(described_class.with_no_vouchers).to_not include(voucher_amount_2)

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
