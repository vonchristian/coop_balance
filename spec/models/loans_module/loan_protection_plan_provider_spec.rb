require 'rails_helper'

module LoansModule
  describe LoanProtectionPlanProvider do
    describe 'associations' do
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :accounts_payable }
      it { is_expected.to have_many :loan_products }
      it { is_expected.to have_many :loans }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :business_name }
      it { is_expected.to validate_uniqueness_of(:business_name).scoped_to(:cooperative_id) }
      it { is_expected.to validate_presence_of :rate }
      it { is_expected.to validate_numericality_of :rate }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:accounts_payable).with_prefix }
    end
  end
end
