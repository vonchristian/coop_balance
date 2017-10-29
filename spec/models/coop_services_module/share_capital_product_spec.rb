require 'rails_helper'

module CoopServicesModule
	describe ShareCapitalProduct do
	  context 'associations' do
      it { is_expected.to belong_to :account }
	  	it { is_expected.to have_many :share_capital_product_shares }
	  	it { is_expected.to have_many :subscribers }
	  end
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
      it { is_expected.to validate_presence_of :account_id }
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :cost_per_share }
      it { is_expected.to validate_numericality_of :cost_per_share }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
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
