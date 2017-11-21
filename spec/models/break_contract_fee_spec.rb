require 'rails_helper'

module CoopConfigurationsModule
  describe BreakContractFee do
    describe 'associations' do
      it { is_expected.to belong_to :account }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :amount }
      it { is_expected.to validate_presence_of :account_id }
      it { is_expected.to validate_numericality_of :amount }
    end
  end
end
