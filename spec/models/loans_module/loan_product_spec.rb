require 'rails_helper'

module LoansModule
  describe LoanProduct do
    describe 'associations' do
      it { is_expected.to belong_to :loans_receivable_current_account }
      it { is_expected.to belong_to :loans_receivable_past_due_account }
    	it { is_expected.to have_many :loans }
      it { is_expected.to have_many :member_borrowers }
      it { is_expected.to have_many :employee_borrowers }
      it { is_expected.to have_many :organization_borrowers }
    	it { is_expected.to have_many :loan_product_charges }
    	it { is_expected.to have_many :charges }
      it { is_expected.to have_many :interest_configs }
      it { is_expected.to have_many :penalty_configs }
    end

    describe 'delegations' do
      let(:loan_product) { create(:loan_product_with_interest_config)}
        it { is_expected.to delegate_method(:rate).to(:current_interest_config).with_prefix }
        it { is_expected.to delegate_method(:interest_revenue_account).to(:current_interest_config) }
        it { is_expected.to delegate_method(:interest_receivable_account).to(:current_interest_config) }
        it { is_expected.to delegate_method(:unearned_interest_income_account).to(:current_interest_config) }
        it { is_expected.to delegate_method(:penalty_receivable_account).to(:current_penalty_config) }
        it { is_expected.to delegate_method(:penalty_revenue_account).to(:current_penalty_config) }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
      it { is_expected.to validate_presence_of :loans_receivable_current_account_id }
    end
    it "#current_interest_config" do
      loan_product = create(:loan_product)
      old_interest_config = create(:interest_config, loan_product: loan_product)
      new_interest_config = create(:interest_config, loan_product: loan_product)

      expect(loan_product.current_interest_config).to eql new_interest_config
    end
  end
end
