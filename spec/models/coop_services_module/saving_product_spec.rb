require 'rails_helper'

module CoopServicesModule
  describe SavingProduct do
    context "associations" do
    	it { is_expected.to have_many :subscribers }
        it { is_expected.to belong_to :account }
    end
    context "validations" do
    	it { is_expected.to validate_presence_of :interest_recurrence }
    	it { is_expected.to validate_presence_of :interest_rate }
    	it do
    		is_expected.to validate_numericality_of(:interest_rate).is_greater_than_or_equal_to(0.01)
    	end
    	it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :account_id }
    	it { is_expected.to validate_uniqueness_of :name }
    end

    describe 'enums' do
      it { is_expected.to define_enum_for(:interest_recurrence).with([:daily, :weekly, :monthly, :quarterly, :annually]) }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
    end

    it ".accounts" do
      saving_product = create(:saving_product)

      expect(saving_product.account).to be_present
      expect(CoopServicesModule::SavingProduct.accounts).to include(saving_product.account_name)
    end
  end
end
