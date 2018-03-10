require 'rails_helper'
module CoopServicesModule
  describe TimeDepositProduct do
    describe 'associations' do
      it { is_expected.to belong_to :account }
      it { is_expected.to belong_to :interest_expense_account }
      it { is_expected.to belong_to :break_contract_account }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :break_contract_fee }
      it { is_expected.to validate_presence_of :minimum_deposit }
      it { is_expected.to validate_presence_of :maximum_deposit }
      it { is_expected.to validate_presence_of :break_contract_fee }
      it { is_expected.to validate_numericality_of :break_contract_fee }
      it { is_expected.to validate_numericality_of :minimum_deposit }
      it { is_expected.to validate_numericality_of :maximum_deposit }

      it { is_expected.to validate_presence_of :account_id }
      it { is_expected.to validate_presence_of :interest_expense_account_id }
      it { is_expected.to validate_presence_of :break_contract_account_id }

      it { is_expected.to validate_presence_of :time_deposit_product_type }
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
      it { is_expected.to validate_uniqueness_of(:account_id) }
    end

    it "#amount_range" do
     	time_deposit_product = build(:time_deposit_product, minimum_deposit: 1, maximum_deposit: 1000)

     	expect(time_deposit_product.amount_range).to eql(1..1000)
    end
  end
end
