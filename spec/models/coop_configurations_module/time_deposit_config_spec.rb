require 'rails_helper'

module CoopConfigurationsModule
  describe TimeDepositConfig do
    describe 'associations' do
      it { is_expected.to belong_to :account }
      it { is_expected.to belong_to :interest_account }
      it { is_expected.to belong_to :break_contract_account }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :account_id }
      it { is_expected.to validate_presence_of :interest_account_id }
      it { is_expected.to validate_presence_of :break_contract_account_id }
      it { is_expected.to validate_presence_of :break_contract_fee }
      it { is_expected.to validate_numericality_of :break_contract_fee }
    end
  end
end
