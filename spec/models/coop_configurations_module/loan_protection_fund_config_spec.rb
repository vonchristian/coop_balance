require 'rails_helper'

module CoopConfigurationsModule
  describe LoanProtectionFundConfig, type: :model do
    describe 'associations' do
      it { is_expected.to belong_to :account }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :account_id }
    end
  end
end
