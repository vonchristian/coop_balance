require 'rails_helper'
module CoopServicesModule
  describe TimeDepositProduct do
    describe 'associations' do
      it { is_expected.to have_one :break_contract_fee }
      it { is_expected.to belong_to :account }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :account_id }
      it { is_expected.to validate_presence_of :time_deposit_product_type }
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
    end

    describe ".set_product_for(time_deposit)" do
      it ".set_time_deposit_product_for_member" do
       	time_deposit_product = create(:time_deposit_product, time_deposit_product_type: 'for_member', minimum_amount: 1, maximum_amount: 1000)
        depositor = create(:member)
        membership = create(:membership, membership_type: 'regular_member', memberable: depositor)
        time_deposit = create(:time_deposit, depositor: depositor)
       	entry = create(:entry_with_credit_and_debit, entry_type: 'time_deposit', commercial_document: time_deposit)
       	CoopServicesModule::TimeDepositProduct.set_product_for(time_deposit)
        expect(time_deposit_product.amount_range).to include(time_deposit.amount_deposited)
       	expect(time_deposit.time_deposit_product).to eql(time_deposit_product)
      end
      it ".set_time_deposit_product_for_non_member" do
        time_deposit_product = create(:time_deposit_product, time_deposit_product_type: 'for_non_member', minimum_amount: 1, maximum_amount: 1000)
        depositor = create(:member)
        membership = create(:membership, membership_type: 'associate_member', memberable: depositor)
        time_deposit = create(:time_deposit, depositor: depositor)
        entry = create(:entry_with_credit_and_debit, entry_type: 'time_deposit', commercial_document: time_deposit)
        CoopServicesModule::TimeDepositProduct.set_product_for(time_deposit)
        expect(time_deposit_product.amount_range).to include(time_deposit.amount_deposited)
        expect(time_deposit.time_deposit_product).to eql(time_deposit_product)
      end
    end

    it "#amount_range" do
     	time_deposit_product = build(:time_deposit_product, minimum_amount: 1, maximum_amount: 1000)

     	expect(time_deposit_product.amount_range).to eql(1..1000)
    end
  end
end
