require 'rails_helper'

module LoansModule
  module Loans
    describe LoanInterest do

      describe 'associations' do
        it { is_expected.to belong_to :loan }
        it { is_expected.to belong_to :employee }
      end
      
      describe 'validations' do
        it { is_expected.to validate_presence_of(:description) }
        it { is_expected.to validate_presence_of(:date) }
        it { is_expected.to validate_presence_of(:amount) }
        it { is_expected.to validate_numericality_of(:amount) }
      end

      describe 'delegations' do
        it { is_expected.to delegate_method(:total_interest_discounts).to(:loan) }
        it { is_expected.to delegate_method(:total_interest_payments).to(:loan) }
        it { is_expected.to delegate_method(:loan_product_interest_revenue_account).to(:loan) }
        it { is_expected.to delegate_method(:name).to(:employee).with_prefix }
      end

      it '#total_interests' do
        loan_interest   = create(:loan_interest, amount: 100)
        loan_interest_2 = create(:loan_interest, amount: 150)

        expect(described_class.total_interests).to eql 250.0
      end
    end
  end
end
