require 'rails_helper'

module MembershipsModule
  describe ShareCapital do
    context 'associations' do
      it { is_expected.to belong_to :cooperative }
    	it { is_expected.to belong_to :subscriber }
    	it { is_expected.to belong_to :share_capital_product }
      it { is_expected.to belong_to :office }
    	# it { is_expected.to have_many :entries }
    end

    context 'delegations' do
      it { is_expected.to delegate_method(:name).to(:subscriber).with_prefix }
      it { is_expected.to delegate_method(:name).to(:office).with_prefix }
    	it { is_expected.to delegate_method(:name).to(:share_capital_product).with_prefix }
      it { is_expected.to delegate_method(:closing_account_fee).to(:share_capital_product).with_prefix }
      it { is_expected.to delegate_method(:closing_account).to(:share_capital_product).with_prefix }
      it { is_expected.to delegate_method(:paid_up_account).to(:share_capital_product).with_prefix }
      it { is_expected.to delegate_method(:closing_account).to(:share_capital_product).with_prefix }
      it { is_expected.to delegate_method(:subscription_account).to(:share_capital_product).with_prefix }
      it { is_expected.to delegate_method(:default_product?).to(:share_capital_product).with_prefix }
      it { is_expected.to delegate_method(:cost_per_share).to(:share_capital_product).with_prefix }
    end

    it '#balance' do
      cash_account = create(:asset)
      employee = create(:user, role: 'teller')
      employee.cash_accounts << cash_account
      share_capital = create(:share_capital)
      deposit = build(:entry, commercial_document: share_capital)
      credit_amount = build(:credit_amount, amount: 5_000, commercial_document: share_capital, account: share_capital.share_capital_product_default_paid_up_account)
      debit_amount = build(:debit_amount,  amount: 5_000, commercial_document: share_capital, account: cash_account)
      deposit.debit_amounts << debit_amount
      deposit.credit_amounts << credit_amount
      deposit.save!

      expect(share_capital.paid_up_balance).to eq(5_000)
    end
    it '#closed?' do
      employee = create(:user, role: 'teller')
      share_capital = create(:share_capital)
      capital_build_up = build(:entry, commercial_document: share_capital)
      capital_build_up.credit_amounts << create(:credit_amount, amount: 5000, commercial_document: share_capital, account: share_capital.share_capital_product_paid_up_account)
      capital_build_up.debit_amounts << create(:debit_amount, amount: 5_000,  commercial_document: share_capital, account: employee.cash_on_hand_account)
      capital_build_up.save

      expect(share_capital.paid_up_balance).to eq 5_000

      closing_account_entry = build(:entry, commercial_document: share_capital)
      closing_account_entry.debit_amounts << create(:debit_amount, amount: share_capital.paid_up_balance,  commercial_document: share_capital, account: share_capital.share_capital_product_paid_up_account)
      closing_account_entry.credit_amounts << create(:credit_amount, amount: share_capital.share_capital_product_closing_account_fee, commercial_document: share_capital, account: share_capital.share_capital_product_closing_account)
      closing_account_entry.save

      expect(share_capital.paid_up_balance).to eq 0
      # expect(share_capital.closed?).to be true
    end

    it "#subscribed_shares" do
      employee = create(:user, role: 'teller')
      share_capital_product = create(:share_capital_product, cost_per_share: 100)
      share_capital = create(:share_capital, share_capital_product: share_capital_product)
      capital_build_up = build(:entry, commercial_document: share_capital.subscriber)
      capital_build_up.credit_amounts << create(:credit_amount, amount: 5000, commercial_document: share_capital, account: share_capital.share_capital_product_paid_up_account)
      capital_build_up.debit_amounts << create(:debit_amount, amount: 5_000, commercial_document: share_capital, account: employee.cash_on_hand_account)
      capital_build_up.save

      expect(share_capital.paid_up_balance).to eq 5_000
      expect(share_capital.paid_up_shares).to eql(50)
    end

  end
end
