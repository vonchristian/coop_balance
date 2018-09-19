require 'rails_helper'

module CoopServicesModule
  describe SavingProduct do
    describe "associations" do
      it { is_expected.to belong_to :cooperative }
    	it { is_expected.to have_many :subscribers }
      it { is_expected.to belong_to :account }
      it { is_expected.to belong_to :closing_account }
      it { is_expected.to belong_to :interest_expense_account }
    end

    describe "validations" do
    	it { is_expected.to validate_presence_of :interest_recurrence }
    	it { is_expected.to validate_presence_of :interest_rate }
    	it do
    		is_expected.to validate_numericality_of(:interest_rate).is_greater_than_or_equal_to(0.01)
        is_expected.to validate_numericality_of(:minimum_balance).is_greater_than_or_equal_to(0.01)
    	end
    	it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
      it { is_expected.to validate_presence_of :account_id }
      it { is_expected.to validate_presence_of :interest_expense_account_id }
      it { is_expected.to validate_presence_of :closing_account_id }

    end

    describe 'enums' do
      it { is_expected.to define_enum_for(:interest_recurrence).with([:daily, :weekly, :monthly, :quarterly, :semi_annually, :annually]) }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
      it { is_expected.to delegate_method(:balance).to(:account) }
      it { is_expected.to delegate_method(:debits_balance).to(:account) }
      it { is_expected.to delegate_method(:credits_balance).to(:account) }
    end

    it ".accounts" do
      saving_product = create(:saving_product)

      expect(saving_product.account).to be_present
      expect(CoopServicesModule::SavingProduct.accounts.pluck(:id)).to include(saving_product.account_id)
    end

    it ".total_subscribers" do
      saving_product = create(:saving_product)
      subscriber = create(:saving, saving_product: saving_product)
      another_subscriber = create(:saving, saving_product: saving_product)
      expect(CoopServicesModule::SavingProduct.total_subscribers).to eq 2
    end

    it "#total_subscribers" do
      saving_product = create(:saving_product)
      subscriber = create(:saving, saving_product: saving_product)

      expect(saving_product.total_subscribers).to eql 1
    end
  end
end
