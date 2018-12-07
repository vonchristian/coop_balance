require 'rails_helper'

module CoopServicesModule
	describe ShareCapitalProduct do
	  context 'associations' do
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :paid_up_account }
      it { is_expected.to belong_to :subscription_account }
	  	it { is_expected.to have_many :subscribers }
	  end
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
      it { is_expected.to validate_presence_of :paid_up_account_id }
      it { is_expected.to validate_presence_of :subscription_account_id }
      it { is_expected.to validate_presence_of :cost_per_share }
      it { is_expected.to validate_numericality_of :cost_per_share }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:paid_up_account).with_prefix }
      it { is_expected.to delegate_method(:name).to(:subscription_account).with_prefix }
    end

    it "#minimum_balance" do
      share_capital_product = build(:share_capital_product, cost_per_share: 100, minimum_number_of_paid_share: 10)

      expect(share_capital_product.minimum_balance).to eql 1_000
    end

    it ".paid_up_accounts" do
      account = create(:asset, name: "Share Capital Product 1")
      account_2 = create(:asset, name: "Share Capital Product 2")
      dummy_account = create(:asset)

      share_capital_product = create(:share_capital_product, paid_up_account: account)
      share_capital_product_2 = create(:share_capital_product, paid_up_account: account_2)

      expect(described_class.paid_up_accounts).to include(account)
      expect(described_class.paid_up_accounts).to include(account_2)
      expect(described_class.paid_up_accounts).to_not include(dummy_account)
    end

    it ".subscription_accounts" do
      account = create(:asset, name: "Share Capital Product 1")
      account_2 = create(:asset, name: "Share Capital Product 2")
      dummy_account = create(:asset)

      share_capital_product = create(:share_capital_product, subscription_account: account)
      share_capital_product_2 = create(:share_capital_product, subscription_account: account_2)

      expect(described_class.subscription_accounts).to include(account)
      expect(described_class.subscription_accounts).to include(account_2)
      expect(described_class.subscription_accounts).to_not include(dummy_account)
    end
	end
end
