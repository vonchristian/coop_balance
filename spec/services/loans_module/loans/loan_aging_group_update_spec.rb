require 'rails_helper'

module LoansModule
  module Loans
    describe LoanAgingGroupUpdate, type: :model do
      describe 'attributes' do
      end

      it '#update_loan_aging_group!' do
        office             = create(:office)
        loan_aging_group_1 = create(:loan_aging_group, office: office, start_num: 0, end_num: 30)
        loan_aging_group_2 = create(:loan_aging_group, office: office, start_num: 31, end_num: 60)
        loan_aging_group_3 = create(:loan_aging_group, office: office, start_num: 61, end_num: 90)
        loan               = create(:loan, office: office)
        loan.terms.create!(term: 90, maturity_date: Date.current - 10.days)

        described_class.new(loan: loan, date: Date.current).update_loan_aging_group!

        expect(loan.loan_aging_group).to eq loan_aging_group_1
        expect(loan.loan_aging_group).to_not eq loan_aging_group_2
        expect(loan.loan_aging_group).to_not eq loan_aging_group_3
      end
    end
  end
end
