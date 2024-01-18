require 'rails_helper'
module CoopServicesModule
  describe TimeDepositProduct do
    describe 'associations' do
      it { should belong_to :cooperative }
    end

    describe 'validations' do
      it { should validate_presence_of :break_contract_fee }
      it { should validate_presence_of :minimum_deposit }
      it { should validate_presence_of :maximum_deposit }
      it { should validate_presence_of :break_contract_fee }
      it { should validate_numericality_of :break_contract_fee }
      it { should validate_numericality_of :minimum_deposit }
      it { should validate_numericality_of :maximum_deposit }
      it { should validate_presence_of :name }
      it { should validate_uniqueness_of :name }
    end

    it '#amount_range' do
      time_deposit_product = build(:time_deposit_product, minimum_deposit: 1, maximum_deposit: 1000)

      expect(time_deposit_product.amount_range).to eql(1..1000)
    end
  end
end
