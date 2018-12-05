require 'rails_helper'

module LoansModule
  describe LoanCoMaker do
    describe 'associations' do
      it { is_expected.to belong_to :loan }
      it { is_expected.to belong_to :co_maker }
    end
    describe 'validations' do
      it { is_expected.to validate_uniqueness_of(:co_maker_id).scoped_to(:loan_id) }
    end
    describe 'delegations' do
      it { is_expected.to delegate_method(:avatar).to(:co_maker) }
      it { is_expected.to delegate_method(:name).to(:co_maker) }
    end
  end
end
