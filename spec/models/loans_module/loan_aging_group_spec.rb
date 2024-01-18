require 'rails_helper'

module LoansModule
  describe LoanAgingGroup do
    describe 'associations' do
      it { should belong_to :office }
      it { should belong_to :receivable_ledger }
      it { should have_many :loan_agings }
      it { should have_many :loans }
      it { should have_many :office_loan_product_aging_groups }
      it { should have_many :office_loan_products }
    end

    describe 'attributes' do
      it { should respond_to(:title) }
      it { should respond_to(:start_num) }
      it { should respond_to(:end_num) }
    end

    describe 'validations' do
      it { should validate_presence_of :title }
      it { should validate_presence_of :start_num }
      it { should validate_presence_of :end_num }
      it { should validate_numericality_of :start_num }
      it { should validate_numericality_of :end_num }
    end

    describe 'delegations' do
      it { should delegate_method(:title).to(:level_two_account_category).with_prefix }
    end

    it '#num_range' do
      group = create(:loan_aging_group, start_num: 0, end_num: 30)

      expect(group.num_range).to eql 0..30
    end

    it '.current_loan_aging_group' do
      current  = create(:loan_aging_group, start_num: 0, end_num: 0)
      past_due = create(:loan_aging_group, start_num: 1, end_num: 30)

      expect(described_class.current_loan_aging_group).to eq current
      expect(described_class.current_loan_aging_group).not_to eq past_due
    end
  end
end
