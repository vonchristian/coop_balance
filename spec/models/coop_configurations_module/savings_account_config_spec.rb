require 'rails_helper'

module CoopConfigurationsModule
  describe SavingsAccountConfig do
    describe 'associations' do
    end
    describe 'validations' do
      it { is_expected.to validate_numericality_of :closing_account_fee }
      it { is_expected.to validate_presence_of :closing_account_fee }
    end
  end
end
