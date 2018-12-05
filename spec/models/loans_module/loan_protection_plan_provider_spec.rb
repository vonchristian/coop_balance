require 'rails_helper'

module LoansModule
  describe LoanProtectionPlanProvider do
    describe 'associations' do
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :accounts_payable }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :business_name }
      it { is_expected.to validate_uniqueness_of(:business_name).scoped_to(:cooperative_id) }
    end
  end
end
