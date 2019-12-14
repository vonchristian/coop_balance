require 'rails_helper'

module LoansModule
  module Loans
    describe TermProcessing, type: :model do
      describe 'attributes' do
        it { is_expected.to respond_to(:loan_id) }
        it { is_expected.to respond_to(:employee_id) }
        it { is_expected.to respond_to(:number_of_days) }
        it { is_expected.to respond_to(:effectivity_date) }
      end
      describe 'validations' do
        it { is_expected.to validate_presence_of :number_of_days }
        it { is_expected.to validate_numericality_of(:number_of_days).only_integer }
        it { is_expected.to validate_numericality_of(:number_of_days).is_greater_than(0) }

        it { is_expected.to validate_presence_of :employee_id }
        it { is_expected.to validate_presence_of :loan_id }
        it { is_expected.to validate_presence_of :effectivity_date }
      end

      it "#process!" do
        loan         = create(:loan)
        loan_officer = create(:loan_officer)

        described_class.new(
          loan_id:          loan.id,
          employee_id:      loan_officer.id,
          effectivity_date: Date.current,
          number_of_days:   60).
          process!

        puts loan.term.inspect
        # expect(term.effectivity_date.to_date).to eql Date.current.to_date
        # expect(term.maturity_date.to_date).to eql (Date.current + 30.days).to_date
        # expect(term.number_of_days).to eq 30
      end

    end
  end
end
