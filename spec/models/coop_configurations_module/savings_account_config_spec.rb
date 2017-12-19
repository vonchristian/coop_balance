require 'rails_helper'

module CoopConfigurationsModule
  describe SavingsAccountConfig do
    describe 'associations' do
      it { is_expected.to belong_to :closing_account }
      it { is_expected.to belong_to :interest_account }
    end
    describe 'validations' do
      it { is_expected.to validate_numericality_of :closing_account_fee }
      it { is_expected.to validate_presence_of :closing_account_fee }
      it { is_expected.to validate_presence_of :closing_account_id }
      it { is_expected.to validate_presence_of :interest_account_id }
    end
  end
end
