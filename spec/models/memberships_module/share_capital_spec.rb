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
      it { is_expected.to delegate_method(:interest_payable_account).to(:share_capital_product).with_prefix }
      it { is_expected.to delegate_method(:equity_account).to(:share_capital_product).with_prefix }
      it { is_expected.to delegate_method(:default_product?).to(:share_capital_product).with_prefix }
      it { is_expected.to delegate_method(:cost_per_share).to(:share_capital_product).with_prefix }
    end


    it "#subscribed_shares" do
      cooperative = create(:cooperative)
      cash_account = create(:asset)
      employee = create(:user, role: 'teller')
      employee.cash_accounts << cash_account
      share_capital_product = create(:share_capital_product, cost_per_share: 100)
      share_capital = create(:share_capital, share_capital_product: share_capital_product)
      capital_build_up = build(:entry, commercial_document: share_capital.subscriber)
      capital_build_up.credit_amounts.build(amount: 5000, commercial_document: share_capital, account: share_capital.share_capital_product_equity_account)
      capital_build_up.debit_amounts.build(amount: 5_000, commercial_document: share_capital, account: cash_account)
      capital_build_up.save!

      expect(share_capital.balance).to eq 5_000
      expect(share_capital.shares).to eql(50)
    end

    it "#entries" do
      cash_account = create(:asset)
      employee = create(:user, role: 'teller')
      employee.cash_accounts << cash_account
      share_capital = create(:share_capital, subscriber: employee)
      share_capital_2 = create(:share_capital)
      deposit = build(:entry, commercial_document: share_capital)
      deposit.credit_amounts <<  build(:credit_amount, amount: 5_000, commercial_document: share_capital, account: share_capital.share_capital_product_equity_account)
      deposit.debit_amounts <<  build(:debit_amount,  amount: 5_000, commercial_document: share_capital, account: cash_account)
      deposit.save!


      expect(share_capital.entries).to include(deposit)
      expect(share_capital_2.entries).to_not include(deposit)


    end
  end
end
