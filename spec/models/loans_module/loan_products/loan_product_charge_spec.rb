require 'rails_helper'

module LoansModule
  module LoanProducts
    describe LoanProductCharge do
      describe 'associations' do
        it { is_expected.to belong_to :account }
        it { is_expected.to belong_to :loan_product }
      end
      describe 'validations' do
        it { is_expected.to validate_presence_of :name }
        it { is_expected.to validate_presence_of :account_id }
        it { is_expected.to validate_presence_of :rate }
        it { is_expected.to validate_presence_of :amount }
        it { is_expected.to validate_numericality_of :rate }
        it { is_expected.to validate_numericality_of :amount }

      end
    end
  end
end
