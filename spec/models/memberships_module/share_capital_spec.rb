require 'rails_helper'

module MembershipsModule
  describe ShareCapital do
    context 'associations' do 
    	it { is_expected.to belong_to :account_owner }
    	it { is_expected.to belong_to :share_capital_product }
    	it { is_expected.to have_many :capital_build_ups }
    end 

    context 'delegations' do 
    	it { is_expected.to delegate_method(:name).to(:share_capital_product) }
    	it { is_expected.to delegate_method(:cost_per_share).to(:share_capital_product) }
    end
    it ".subscribed_shares" do
    	share_capital_product = create(:share_capital_product, cost_per_share: 10)
    	share_capital = create(:share_capital, share_capital_product: share_capital_product)
    	another_share_capital = create(:share_capital, share_capital_product: share_capital_product)
      
      capital_build_up = create(:entry_with_credit_and_debit, commercial_document: share_capital, entry_type: 'capital_build_up') 
      another_capital_build_up = create(:entry_with_credit_and_debit, commercial_document: another_share_capital, entry_type: 'capital_build_up') 
    
      expect(MembershipsModule::ShareCapital.subscribed_shares).to eql(20) 
    end

    it '#subscribed_shares' do 
    	share_capital_product = create(:share_capital_product, cost_per_share: 10)
    	share_capital = create(:share_capital, share_capital_product: share_capital_product)
      capital_build_up = create(:entry_with_credit_and_debit, commercial_document: share_capital, entry_type: 'capital_build_up') 
    
      expect(share_capital.subscribed_shares).to eql(10)
    end
  end 
end
