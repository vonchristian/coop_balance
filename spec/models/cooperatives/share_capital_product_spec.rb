require 'rails_helper'

module Cooperatives
	describe ShareCapitalProduct do
	  context 'associations' do
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :equity_account }
      it { is_expected.to belong_to :interest_payable_account }
	  	it { is_expected.to have_many :subscribers }
	  end
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:cooperative_id) }
      it { is_expected.to validate_presence_of :equity_account_id }
      it { is_expected.to validate_presence_of :cost_per_share }
      it { is_expected.to validate_numericality_of :cost_per_share }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:equity_account).with_prefix }
    end

    it "#minimum_balance" do
      share_capital_product = build(:share_capital_product, cost_per_share: 100, minimum_number_of_paid_share: 10)

      expect(share_capital_product.minimum_balance).to eql 1_000
    end

    it ".paid_up_accounts" do
      account = create(:equity, name: "Share Capital Product 1")
      account_2 = create(:equity, name: "Share Capital Product 2")
      dummy_account = create(:asset)

      share_capital_product = create(:share_capital_product, equity_account: account)
      share_capital_product_2 = create(:share_capital_product, equity_account: account_2)

      expect(described_class.equity_accounts).to include(account)
      expect(described_class.equity_accounts).to include(account_2)
      expect(described_class.equity_accounts).to_not include(dummy_account)
    end
	end
end
