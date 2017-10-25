require 'rails_helper'
module CoopServicesModule
  describe TimeDepositProduct do
    describe 'associations' do 
      it { is_expected.to have_one :break_contract_fee }
    end
    
    it ".set_product_for(time_deposit)" do 
     	time_deposit_product = create(:time_deposit_product, minimum_amount: 1, maximum_amount: 1000)
     	time_deposit = create(:time_deposit)
     	entry = create(:entry_with_credit_and_debit, entry_type: 'time_deposit', commercial_document: time_deposit)
     	

     	CoopServicesModule::TimeDepositProduct.set_product_for(time_deposit)
      expect(time_deposit_product.amount_range).to include(time_deposit.amount_deposited)
     	expect(time_deposit.time_deposit_product.id).to eq(time_deposit_product.id)
    end

    it "#amount_range" do 
     	time_deposit_product = build(:time_deposit_product, minimum_amount: 1, maximum_amount: 1000)

     	expect(time_deposit_product.amount_range).to eql(1..1000)
    end
  end
end