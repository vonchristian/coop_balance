require 'rails_helper'

module LoansModule
  module Loans
    describe LoanTerm, type: :model do

      describe 'attributes' do
        it { is_expected.to respond_to(:loan_id) }
        it { is_expected.to respond_to(:term_id) }
      end

      describe 'associations' do
        it { is_expected.to belong_to :loan }
        it { is_expected.to belong_to :term }
      end

      describe 'validations' do
        it 'unique term' do
          loan = create(:loan)
          term = create(:term)
          create(:loan_term, loan: loan, term: term)
          loan_term = build(:loan_term, loan: loan, term: term)
          loan_term.save

          expect(loan_term.errors[:term_id]).to eq ['has already been taken']
        end 
      end
    end
  end
end
