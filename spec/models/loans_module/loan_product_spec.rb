require 'rails_helper'

module LoansModule
  describe LoanProduct do
    describe 'associations' do
    	it { is_expected.to have_many :loans }
    	it { is_expected.to have_many :loan_product_charges }
    	it { is_expected.to have_many :charges }
      it { is_expected.to have_one :loan_product_interest }
    end

    describe 'delegations' do
      it { is_expected.to delegate_method(:name).to(:account).with_prefix }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_uniqueness_of :name }
      it { is_expected.to validate_presence_of :account_id }
    end
    describe 'nested attributes' do
      it do
        is_expected.to accept_nested_attributes_for(:loan_product_interest)
      end
    end

  end
end
