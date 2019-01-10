require 'rails_helper'

module LoansModule
  describe LoanProduct do
    describe 'associations' do
      it { is_expected.to belong_to :loan_protection_plan_provider }
      it { is_expected.to belong_to :cooperative }
      it { is_expected.to belong_to :current_account }
      it { is_expected.to belong_to :past_due_account }
      it { is_expected.to belong_to :restructured_account }
    	it { is_expected.to have_many :loans }
      it { is_expected.to have_many :member_borrowers }
      it { is_expected.to have_many :employee_borrowers }
      it { is_expected.to have_many :organization_borrowers }
    	it { is_expected.to have_many :loan_product_charges }
      it { is_expected.to have_many :interest_configs }
      it { is_expected.to have_many :penalty_configs }
      it { is_expected.to have_many :interest_predeductions }
    end

    describe 'delegations' do
      let(:loan_product) { create(:loan_product_with_interest_config)}
        it { is_expected.to delegate_method(:rate).to(:current_interest_config).with_prefix }
        it { is_expected.to delegate_method(:amortization_type).to(:current_interest_config).with_prefix }
        it { is_expected.to delegate_method(:prededuction_type).to(:current_interest_config).with_prefix }
        it { is_expected.to delegate_method(:prededucted_rate).to(:current_interest_config).with_prefix }
        it { is_expected.to delegate_method(:calculation_type).to(:current_interest_config).with_prefix }
        it { is_expected.to delegate_method(:rate_type).to(:current_interest_config).with_prefix }
        it { is_expected.to delegate_method(:interest_revenue_account).to(:current_interest_config) }
        it { is_expected.to delegate_method(:interest_receivable_account).to(:current_interest_config) }
        it { is_expected.to delegate_method(:unearned_interest_income_account).to(:current_interest_config) }
        it { is_expected.to delegate_method(:penalty_receivable_account).to(:current_penalty_config) }
        it { is_expected.to delegate_method(:penalty_revenue_account).to(:current_penalty_config) }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
      it { is_expected.to validate_presence_of :current_account_id }
    end

  end
end
