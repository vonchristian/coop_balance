require 'rails_helper'

module LoansModule
  describe LoanProductInterest do
    describe 'associations' do
      it { is_expected.to belong_to :loan_product }
      it { is_expected.to belong_to :account }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :account_id }
    end
  end
end
