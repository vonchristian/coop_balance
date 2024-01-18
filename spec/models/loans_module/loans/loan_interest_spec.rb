require 'rails_helper'

module LoansModule
  module Loans
    describe LoanInterest do
      describe 'associations' do
        it { should belong_to :loan }
        it { should belong_to :employee }
      end

      describe 'validations' do
        it { should validate_presence_of(:description) }
        it { should validate_presence_of(:date) }
        it { should validate_presence_of(:amount) }
        it { should validate_numericality_of(:amount) }
      end

      describe 'delegations' do
        it { should delegate_method(:name).to(:employee).with_prefix }
      end

      it '#total_interests' do
        create(:loan_interest, amount: 100)
        create(:loan_interest, amount: 150)

        expect(described_class.total_interests).to be 250.0
      end
    end
  end
end
