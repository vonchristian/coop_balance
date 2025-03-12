require 'rails_helper'

module LoansModule
  module Loans
    describe LoanAging do
      describe 'attributes' do
        it { should respond_to(:loan_id) }
        it { should respond_to(:loan_aging_group_id) }
        it { should respond_to(:receivable_account_id) }
        it { should respond_to(:date) }
      end

      describe 'associations' do
        it { should belong_to :loan }
        it { should belong_to :loan_aging_group }
        it { should belong_to :receivable_account }
      end

      describe 'validations' do
        it { should validate_presence_of :date }

        it 'validate_uniqueness_of(:loan_aging_group_id).scoped_to(:loan_id)' do
          loan             = create(:loan)
          loan_aging_group = create(:loan_aging_group)
          create(:loan_aging, loan: loan, loan_aging_group: loan_aging_group)
          loan_aging = build(:loan_aging, loan: loan, loan_aging_group: loan_aging_group)
          loan_aging.save

          expect(loan_aging.errors[:loan_aging_group_id]).to eql [ 'has already been taken' ]
        end

        it 'validate_uniqueness_of(:receivable_account_id).scoped_to(:loan_id)' do
          loan               = create(:loan)
          receivable_account = create(:asset)
          create(:loan_aging, loan: loan, receivable_account: receivable_account)
          loan_aging = build(:loan_aging, loan: loan, receivable_account: receivable_account)
          loan_aging.save

          expect(loan_aging.errors[:receivable_account_id]).to eql [ 'has already been taken' ]
        end
      end

      it '.current' do
        old    = create(:loan_aging, date: Date.current.last_month)
        recent = create(:loan_aging, date: Date.current)

        expect(described_class.current).to eql recent
        expect(described_class.current).not_to eql old
      end
    end
  end
end
