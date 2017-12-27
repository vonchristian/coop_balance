require 'rails_helper'

module MembershipsModule
  describe ShareCapital do
    context 'associations' do
    	it { is_expected.to belong_to :subscriber }
    	it { is_expected.to belong_to :share_capital_product }
      it { is_expected.to belong_to :office }
    	# it { is_expected.to have_many :entries }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :share_capital_product_id }
    end
    describe 'enums' do
      it do
        is_expected.to define_enum_for(:status).with([:active, :inactive, :closed])
      end
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


    	it { is_expected.to delegate_method(:cost_per_share).to(:share_capital_product).with_prefix }
    end
    it ".subscribed_shares" do
    	share_capital_product = create(:share_capital_product, cost_per_share: 10)
    	share_capital = create(:share_capital, share_capital_product: share_capital_product)
    	another_share_capital = create(:share_capital, share_capital_product: share_capital_product)

      capital_build_up = create(:entry_with_credit_and_debit, commercial_document: share_capital)
      another_capital_build_up = create(:entry_with_credit_and_debit, commercial_document: another_share_capital)

      expect(MembershipsModule::ShareCapital.subscribed_shares).to eql(20)
    end

    it '#subscribed_shares' do
    	share_capital_product = create(:share_capital_product, cost_per_share: 10)
    	share_capital = create(:share_capital, share_capital_product: share_capital_product)
      capital_build_up = create(:entry_with_credit_and_debit, commercial_document: share_capital)

      expect(share_capital.subscribed_shares).to eql(10)
    end
    it ".entries" do
      share_capital = create(:share_capital)
      capital_build_up = create(:entry_with_credit_and_debit, commercial_document: share_capital)
      expect(share_capital.entries.count).to eql(2)
    end

    it '#balance' do
      employee = create(:user, role: 'teller')
      share_capital = create(:share_capital)
      capital_build_up = build(:entry, commercial_document: share_capital)
      credit_amount = create(:credit_amount, amount: 5000, entry: capital_build_up, commercial_document: share_capital, account: share_capital.share_capital_product_paid_up_account)
      debit_amount = create(:debit_amount, amount: 5_000, entry: capital_build_up, commercial_document: share_capital, account: employee.cash_on_hand_account)
      capital_build_up.save

      expect(share_capital.balance).to eq(5_000)
    end
    it '#closed?' do
      employee = create(:user, role: 'teller')
      share_capital = create(:share_capital)
      capital_build_up = build(:entry, commercial_document: share_capital)
      credit_amount = create(:credit_amount, amount: 5000, entry: capital_build_up, commercial_document: share_capital, account: share_capital.share_capital_product_paid_up_account)
      debit_amount = create(:debit_amount, amount: 5_000, entry: capital_build_up, commercial_document: share_capital, account: employee.cash_on_hand_account)
      capital_build_up.save

      expect(share_capital.balance).to eq 5_000

      closing_account_entry = build(:entry, commercial_document: share_capital)
      credit_amount = create(:credit_amount, amount: (share_capital.balance - share_capital.share_capital_product_closing_account_fee) , entry: closing_account_entry, commercial_document: share_capital, account: employee.cash_on_hand_account)
      debit_amount = create(:debit_amount, amount: share_capital.balance, entry: closing_account_entry, commercial_document: share_capital, account: share_capital.share_capital_product_paid_up_account)
      credit_amount = create(:credit_amount, amount: share_capital.share_capital_product_closing_account_fee, entry: closing_account_entry, commercial_document: share_capital, account: share_capital.share_capital_product_closing_account)
      closing_account_entry.save

      expect(share_capital.balance).to eq 0
      # expect(share_capital.closed?).to be true
    end
  end
end
