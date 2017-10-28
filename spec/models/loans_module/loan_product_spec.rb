require 'rails_helper'

module LoansModule
  describe LoanProduct do
    describe 'associations' do
    	it { is_expected.to have_many :loans }
    	it { is_expected.to have_many :loan_product_charges }
    	it { is_expected.to have_many :charges }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
      it { is_expected.to validate_presence_of :interest_rate }
      it { is_expected.to validate_numericality_of :interest_rate }
      it { is_expected.to validate_presence_of :account_id }
    end

  end
end
