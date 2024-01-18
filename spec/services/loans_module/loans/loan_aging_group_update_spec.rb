require 'rails_helper'

module LoansModule
  module Loans
    describe LoanAgingGroupUpdate, type: :model do
      describe 'attributes' do
      end

      it '#process!' do
        office              = create(:office)
        loan_aging_group_0  = create(:loan_aging_group, office: office, start_num: 0, end_num: 0)
        loan_aging_group_1  = create(:loan_aging_group, office: office, start_num: 1, end_num: 30)
        create(:loan_aging_group, office: office, start_num: 31, end_num: 60)
        create(:loan_aging_group, office: office, start_num: 61, end_num: 90)
        create(:loan_aging_group, office: office, start_num: 91, end_num: 180)
        create(:loan_aging_group, office: office, start_num: 181, end_num: 365)
        create(:loan_aging_group, office: office, start_num: 366, end_num: 999_999)
        loan_product = create(:loan_product)
        create(:office_loan_product, office: office, loan_product: loan_product)
        loan = create(:loan, office: office, loan_product: loan_product, loan_aging_group: loan_aging_group_0)
        term = loan.create_term!(number_of_days: 90, effectivity_date: Time.zone.now, maturity_date: 90.days.from_now)

        expect(loan.loan_aging_group).to eq loan_aging_group_0

        puts loan.number_of_days_past_due(date: Time.zone.now)

        # 30 days past due
        term.update!(number_of_days: 30, effectivity_date: 60.days.ago, maturity_date: 30.days.ago)

        described_class.new(loan: loan, date: Time.zone.now).process!

        expect(loan.loan_aging_group).to eql loan_aging_group_1

        puts loan.number_of_days_past_due(date: Time.zone.now)

        # 60 days past due
        loan.term.update(number_of_days: 60, effectivity_date: 120.days.ago, maturity_date: 60.days.ago)

        described_class.new(loan: loan, date: Time.zone.now).process!

        # expect(loan.loan_aging_group).to eq loan_aging_group_2

        puts loan.number_of_days_past_due(date: Time.zone.now)

        # 90 days past due
        loan.term.update(number_of_days: 90, effectivity_date: 180.days.ago, maturity_date: 90.days.ago)
        described_class.new(loan: loan, date: Time.zone.now).process!

        # expect(loan.loan_aging_group).to eq loan_aging_group_3

        puts loan.number_of_days_past_due(date: Time.zone.now)

        # 180 days past due

        loan.term.update(number_of_days: 90, effectivity_date: 270.days.ago, maturity_date: 180.days.ago)
        described_class.new(loan: loan, date: Time.zone.now).process!

        # expect(loan.loan_aging_group).to eq loan_aging_group_4

        puts loan.number_of_days_past_due(date: Time.zone.now)

        # 365 days past due

        loan.term.update(number_of_days: 90, effectivity_date: 720.days.ago, maturity_date: 365.days.ago)
        described_class.new(loan: loan, date: Time.zone.now).process!

        #  expect(loan.loan_aging_group).to eq loan_aging_group_5

        puts loan.number_of_days_past_due(date: Time.zone.now)

        # over one year days past due

        loan.term.update(number_of_days: 90, effectivity_date: 720.days.ago, maturity_date: 366.days.ago)
        described_class.new(loan: loan, date: Time.zone.now).process!

        #  expect(loan.loan_aging_group).to eq loan_aging_group_6

        puts loan.number_of_days_past_due(date: Time.zone.now)
      end
    end
  end
end
