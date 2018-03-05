require 'rails_helper'

module LoansModule
  module LoanProducts
    describe InterestConfig, type: :model do
      describe 'associations' do
        it { is_expected.to belong_to :loan_product }
        it { is_expected.to belong_to :interest_revenue_account }
        it { is_expected.to belong_to :unearned_interest_income_account}
      end
      describe "validations" do
        it { is_expected.to validate_presence_of :rate }
        it { is_expected.to validate_presence_of :unearned_interest_income_account_id }
        it { is_expected.to validate_presence_of :interest_revenue_account_id }
        it { is_expected.to validate_numericality_of :rate }
      end
    end
  end
end
