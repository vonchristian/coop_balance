require 'rails_helper'

module LoansModule
  module Loans
    describe LoanAging do
      describe 'attributes' do
        it { is_expected.to respond_to(:loan_id) }
        it { is_expected.to respond_to(:loan_aging_group_id) }
        it { is_expected.to respond_to(:date) }
      end

      describe 'associations' do
        it { is_expected.to belong_to :loan }
        it { is_expected.to belong_to :loan_aging_group }
      end

      describe 'validations' do
        it { is_expected.to validate_presence_of :date }
        it { is_expected.to validate_uniqueness_of(:loan_aging_group_id).scoped_to(:loan_id) }
      end

      it '.current' do
        old = create(:loan_aging, date: Date.current.last_month)
        recent = create(:loan_aging, date: Date.current)

        expect(described_class.current).to eql recent 
        expect(described_class.current).to_not eql old
      end
    end
  end
end
