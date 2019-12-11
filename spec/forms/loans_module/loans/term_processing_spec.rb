require 'rails_helper'

module LoansModule
  module Loans
    describe TermProcessing, type: :model do
      describe 'attributes' do
        it { is_expected.to respond_to(:loan_id) }
        it { is_expected.to respond_to(:employee_id) }
        it { is_expected.to respond_to(:term) }
        it { is_expected.to respond_to(:effectivity_date) }
      end
      describe 'validations' do
        it { is_expected.to validate_presence_of :term }
        it { is_expected.to validate_numericality_of :term }
        it { is_expected.to validate_presence_of :employee_id }
        it { is_expected.to validate_presence_of :loan_id }
        it { is_expected.to validate_presence_of :effectivity_date }
      end

      it "#process!" do
        loan         = create(:loan)
        loan_officer = create(:loan_officer)

        described_class.new(loan_id: loan.id, employee_id: loan_officer.id, effectivity_date: Date.current, term: 30).process!

        term = loan.terms.last

        expect(term.effectivity_date.to_date).to eql Date.current.to_date
        expect(term.maturity_date.to_date).to eql (Date.current + 30.days).to_date
        expect(term.term).to eq 30
      end

    end
  end
end
