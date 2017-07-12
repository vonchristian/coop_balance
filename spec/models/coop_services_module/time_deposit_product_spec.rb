require 'rails_helper'
module CoopServicesModule
  describe TimeDepositProduct do
    describe "enums" do 
     	it { is_expected.to define_enum_for(:interest_recurrence).with([:weekly, :monthly, :annually]) }
    end
    it ".set_product_for(time_deposit)" do 
     	time_deposit_product = create(:time_deposit_product, minimum_amount: 1, maximum_amount: 1000)
     	time_deposit = create(:time_deposit)
     	entry = create(:entry_with_credit_and_debit, commercial_document: time_deposit)
     	

     	CoopServicesModule::TimeDepositProduct.set_product_for(time_deposit)
     	expect(time_deposit.time_deposit_product).to eql(time_deposit_product)
    end

    it "#range" do 
     	time_deposit_product = build(:time_deposit_product, minimum_amount: 100, maximum_amount: 1000)

     	expect(time_deposit_product.range).to eql(100..1000)
    end
  end
end