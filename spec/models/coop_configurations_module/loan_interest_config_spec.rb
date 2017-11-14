require 'rails_helper'

module CoopConfigurationsModule
  describe LoanInterestConfig do
    describe 'associations' do
      it { is_expected.to belong_to :account }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :account_id }
    end
    describe ".account_to_debit" do
      it 'if account exists' do
        loan_interest_config = create(:loan_interest_config)

        expect(CoopConfigurationsModule::LoanInterestConfig.account_to_debit.id).to eql(loan_interest_config.account.id)
      end
      it 'if account do not exists' do
        account = create(:revenue, name: "Interest Income from Loans")
        CoopConfigurationsModule::LoanInterestConfig.destroy_all

        expect(CoopConfigurationsModule::LoanInterestConfig.account_to_debit.name).to eql("Interest Income from Loans")
      end
    end
  end
end
