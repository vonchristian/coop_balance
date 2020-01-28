require 'rails_helper'

module LoansModule
  module Loans
    describe LoanPenalty do
      describe 'associations' do
        it { is_expected.to belong_to :loan }
        it { is_expected.to belong_to :employee }
      end

      describe 'validations' do 
        it { is_expected.to validate_presence_of :amount }
        it { is_expected.to validate_presence_of :date }
        it { is_expected.to validate_presence_of :description }
        it { is_expected.to validate_numericality_of :amount }
      end 

      describe 'delegations' do 
        it { is_expected.to delegate_method(:name).to(:employee).with_prefix }
      end 

      it '.total_amount' do 
        penalty_1 = create(:loan_penalty, amount: 100)
        penalty_2 = create(:loan_penalty, amount: 100)

        expect(described_class.total_amount).to eql 200 
      end 

    end
  end
end
