require 'rails_helper'

module LoansModule
  describe LoanProduct do
    describe 'associations' do
      it { is_expected.to belong_to :account }
      it { is_expected.to belong_to :interest_account }
      it { is_expected.to belong_to :penalty_account }
    	it { is_expected.to have_many :loans }
      it { is_expected.to have_many :member_borrowers }
      it { is_expected.to have_many :employee_borrowers }
      it { is_expected.to have_many :organization_borrowers }
    	it { is_expected.to have_many :loan_product_charges }
    	it { is_expected.to have_many :charges }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
      it { is_expected.to delegate_method(:name).to(:interest_account).with_prefix }
      it { is_expected.to delegate_method(:name).to(:penalty_account).with_prefix }


    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
      it { is_expected.to validate_presence_of :account_id }
      it { is_expected.to validate_presence_of :interest_account_id }
      it { is_expected.to validate_presence_of :penalty_account_id }
      it { is_expected.to validate_presence_of :interest_rate }
      it { is_expected.to validate_presence_of :penalty_rate }
      it { is_expected.to validate_numericality_of :interest_rate }
      it { is_expected.to validate_numericality_of :penalty_rate }
    end
  end
end
