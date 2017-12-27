require 'rails_helper'

module CoopServicesModule
	describe ShareCapitalProduct do
	  context 'associations' do
      it { is_expected.to belong_to :paid_up_account }
      it { is_expected.to belong_to :closing_account }
      it { is_expected.to belong_to :subscription_account }
	  	it { is_expected.to have_many :share_capital_product_shares }
	  	it { is_expected.to have_many :subscribers }
	  end
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
      it { is_expected.to validate_presence_of :paid_up_account_id }
      it { is_expected.to validate_presence_of :subscription_account_id }
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :cost_per_share }
      it { is_expected.to validate_numericality_of :cost_per_share }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:paid_up_account).with_prefix }
      it { is_expected.to delegate_method(:name).to(:subscription_account).with_prefix }

    end

    it ".paid_up_accounts" do
      share_capital_product = create(:share_capital_product)

      expect(share_capital_product.paid_up_account).to be_present
      expect(CoopServicesModule::ShareCapitalProduct.paid_up_accounts.pluck(:id)).to include(share_capital_product.paid_up_account_id)
    end

    it '#total_shares' do
    	share_capital_product = create(:share_capital_product, cost_per_share: 10)
	  	share_capital_product_share = create(:share_capital_product_share, share_capital_product: share_capital_product, share_count: 1000)

	    expect(share_capital_product.total_shares).to eql 1000
	  end

	  it '#total_subscribed' do
	    share_capital_product = create(:share_capital_product, cost_per_share: 10)
	  	share_capital_product_share = create(:share_capital_product_share, share_capital_product: share_capital_product, share_count: 1000)
	  	subscriber = create(:share_capital)

	  	capital_build_up = create(:entry_with_credit_and_debit, commercial_document: subscriber)
      expect(share_capital_product.total_subscribed).to eql(1)
    end
    it '#total_available_shares' do
      pending "add some examples"
    end
	end
end
