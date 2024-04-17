require 'rails_helper'

module DepositsModule
  describe ShareCapital do
    describe 'attributes' do
      it { should respond_to :share_capital_product_id }
      it { should respond_to :has_minimum_balance }
    end

    describe 'associations' do
      it { should belong_to :cooperative }
      it { should belong_to :subscriber }
      it { should belong_to :share_capital_product }
      it { should belong_to :office }
      it { should belong_to :share_capital_equity_account }
      it { should have_many :entries }
    end

    describe 'delegations' do
      it { should delegate_method(:name).to(:subscriber).with_prefix }
      it { should delegate_method(:name).to(:office).with_prefix }
      it { should delegate_method(:name).to(:share_capital_product).with_prefix }
      it { should delegate_method(:equity_account).to(:share_capital_product).with_prefix }
      it { should delegate_method(:default_product?).to(:share_capital_product).with_prefix }
      it { should delegate_method(:cost_per_share).to(:share_capital_product).with_prefix }
      it { should delegate_method(:balance).to(:share_capital_equity_account) }
      it { should delegate_method(:name).to(:share_capital_equity_account).with_prefix }
    end

    it '.withdrawn' do
      share_capital           = create(:share_capital, withdrawn_at: nil)
      withdrawn_share_capital = create(:share_capital, withdrawn_at: Date.current)

      expect(described_class.withdrawn).to include(withdrawn_share_capital)
      expect(described_class.withdrawn).not_to include(share_capital)
    end

    it '#subscribed_shares' do
      create(:cooperative)
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
      expect(share_capital.shares).to be(50)
    end
  end
end
