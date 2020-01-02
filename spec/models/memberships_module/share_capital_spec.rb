require 'rails_helper'

module MembershipsModule
  describe ShareCapital do
    describe 'attributes' do
      it { is_expected.to respond_to :share_capital_product_id }
      it { is_expected.to respond_to :has_minimum_balance }
    end
    describe 'associations' do
      it { is_expected.to belong_to :cooperative }
    	it { is_expected.to belong_to :subscriber }
    	it { is_expected.to belong_to :share_capital_product }
      it { is_expected.to belong_to :office }
      it { is_expected.to belong_to :share_capital_equity_account }
      it { is_expected.to have_many :accountable_accounts }
      it { is_expected.to have_many :accounts }
      it { is_expected.to have_many :entries }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:subscriber).with_prefix }
      it { is_expected.to delegate_method(:name).to(:office).with_prefix }
    	it { is_expected.to delegate_method(:name).to(:share_capital_product).with_prefix }
      it { is_expected.to delegate_method(:equity_account).to(:share_capital_product).with_prefix }
      it { is_expected.to delegate_method(:default_product?).to(:share_capital_product).with_prefix }
      it { is_expected.to delegate_method(:cost_per_share).to(:share_capital_product).with_prefix }
      it { is_expected.to delegate_method(:balance).to(:share_capital_equity_account) }
      it { is_expected.to delegate_method(:name).to(:share_capital_equity_account).with_prefix }

    end

    it '.withdrawn' do
      share_capital           = create(:share_capital, withdrawn_at: nil)
      withdrawn_share_capital = create(:share_capital, withdrawn_at: Date.current)

      expect(described_class.withdrawn).to include(withdrawn_share_capital)
      expect(described_class.withdrawn).to_not include(share_capital)
    end

    it "#subscribed_shares" do
      cooperative = create(:cooperative)
      cash_account = create(:asset)
      employee = create(:user, role: 'teller')
      employee.cash_accounts << cash_account
      share_capital_product = create(:share_capital_product, cost_per_share: 100)
      share_capital    = create(:share_capital, share_capital_product: share_capital_product)
      capital_build_up = build(:entry, recorder: employee, office: employee.office, cooperative: employee.cooperative, commercial_document: share_capital.subscriber)
      capital_build_up.credit_amounts.build(amount: 5000, commercial_document: share_capital, account: share_capital.share_capital_equity_account)
      capital_build_up.debit_amounts.build(amount: 5_000, commercial_document: share_capital, account: cash_account)
      capital_build_up.save!

      expect(share_capital.balance).to eq 5_000
      expect(share_capital.shares).to eql(50)
    end
  end
end
