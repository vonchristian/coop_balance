require 'rails_helper'

module LoansModule
  describe LoanProtectionPlanProvider do
    describe 'associations' do
      it { should belong_to :cooperative }
      it { should belong_to :accounts_payable }
      it { should have_many :loan_products }
      it { should have_many :loans }
    end

    describe 'validations' do
      it { should validate_presence_of :business_name }
      it { should validate_uniqueness_of(:business_name).scoped_to(:cooperative_id) }
      it { should validate_presence_of :rate }
      it { should validate_numericality_of :rate }
    end

    describe 'delegations' do
      it { should delegate_method(:name).to(:accounts_payable).with_prefix }
    end
  end
end
