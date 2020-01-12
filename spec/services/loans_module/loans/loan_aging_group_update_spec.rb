require 'rails_helper'

module LoansModule
  module Loans
    describe LoanAgingGroupUpdate, type: :model do
      describe 'attributes' do
      end

      it '#update_loan_aging_group!' do
        office              = create(:office)
        loan_aging_group_0  = create(:loan_aging_group, office: office, start_num: 0, end_num: 0)
        loan_aging_group_1  = create(:loan_aging_group, office: office, start_num: 1, end_num: 30)
        loan_aging_group_2  = create(:loan_aging_group, office: office, start_num: 31, end_num: 60)
        loan_aging_group_3  = create(:loan_aging_group, office: office, start_num: 61, end_num: 90)
        loan_aging_group_4  = create(:loan_aging_group, office: office, start_num: 91, end_num: 180)
        loan_aging_group_5  = create(:loan_aging_group, office: office, start_num: 181, end_num: 365)
        loan_aging_group_6  = create(:loan_aging_group, office: office, start_num: 366, end_num: 999999)
        loan_product        = create(:loan_product)
        office_loan_product = create(:office_loan_product, office: office, loan_product: loan_product)
        loan                = create(:loan, office: office, loan_product: loan_product)
        loan.create_term!(number_of_days: 90, effectivity_date: Date.current,  maturity_date: Date.current + 90.days)
       
        office_loan_product_aging_group_0 = create(:office_loan_product_aging_group, loan_aging_group: loan_aging_group_0, office_loan_product: office_loan_product)
        office_loan_product_aging_group_1 = create(:office_loan_product_aging_group, loan_aging_group: loan_aging_group_1, office_loan_product: office_loan_product)
        office_loan_product_aging_group_2 = create(:office_loan_product_aging_group, loan_aging_group: loan_aging_group_2, office_loan_product: office_loan_product)
        office_loan_product_aging_group_3 = create(:office_loan_product_aging_group, loan_aging_group: loan_aging_group_3, office_loan_product: office_loan_product)
        office_loan_product_aging_group_4 = create(:office_loan_product_aging_group, loan_aging_group: loan_aging_group_4, office_loan_product: office_loan_product)
        office_loan_product_aging_group_5 = create(:office_loan_product_aging_group, loan_aging_group: loan_aging_group_5, office_loan_product: office_loan_product)
        office_loan_product_aging_group_6 = create(:office_loan_product_aging_group, loan_aging_group: loan_aging_group_6, office_loan_product: office_loan_product)
       
        #current 
        described_class.new(loan: loan, date: Date.current).update_loan_aging_group!

        expect(loan.loan_aging_group).to eq loan_aging_group_0
        expect(loan.receivable_account.level_one_account_category).to eql office_loan_product_aging_group_0.level_one_account_category
        puts loan.number_of_days_past_due
        
        #30 days past due 
        loan.term.update!(number_of_days: 30, effectivity_date: Date.current - 60.days, maturity_date: Date.current - 30.days)

        described_class.new(loan: loan, date: Date.current + 30.days).update_loan_aging_group!
        
        expect(loan.loan_aging_group).to eq loan_aging_group_1
        expect(loan.receivable_account.level_one_account_category).to eql office_loan_product_aging_group_1.level_one_account_category
        puts loan.number_of_days_past_due
        
        #60 days past due 
        loan.term.update(number_of_days: 60, effectivity_date: Date.current - 120.days, maturity_date: Date.current - 60.days)
        
        described_class.new(loan: loan, date: Date.current + 60.days).update_loan_aging_group!
        
        expect(loan.loan_aging_group).to eq loan_aging_group_2
        expect(loan.receivable_account.level_one_account_category).to eql office_loan_product_aging_group_2.level_one_account_category
        puts loan.number_of_days_past_due
        
        #90 days past due 
        loan.term.update(number_of_days: 90, effectivity_date: Date.current - 180.days, maturity_date: Date.current - 90.days)
        described_class.new(loan: loan, date: Date.current + 90.days).update_loan_aging_group!
        
        expect(loan.loan_aging_group).to eq loan_aging_group_3
        expect(loan.receivable_account.level_one_account_category).to eql office_loan_product_aging_group_3.level_one_account_category
        puts loan.number_of_days_past_due
        
        #180 days past due 
       
        loan.term.update(number_of_days: 90, effectivity_date: Date.current - 270.days, maturity_date: Date.current - 180.days)
        described_class.new(loan: loan, date: Date.current + 180.days).update_loan_aging_group!
       
        expect(loan.loan_aging_group).to eq loan_aging_group_4
        expect(loan.receivable_account.level_one_account_category).to eql office_loan_product_aging_group_4.level_one_account_category
        puts loan.number_of_days_past_due
        
         #365 days past due 
       
         loan.term.update(number_of_days: 90, effectivity_date: Date.current - 720.days, maturity_date: Date.current - 365.days)
         described_class.new(loan: loan, date: Date.current + 365.days).update_loan_aging_group!
        
         expect(loan.loan_aging_group).to eq loan_aging_group_5
         expect(loan.receivable_account.level_one_account_category).to eql office_loan_product_aging_group_5.level_one_account_category
         puts loan.number_of_days_past_due
        
         #over one year days past due 
       
         loan.term.update(number_of_days: 90, effectivity_date: Date.current - 720.days, maturity_date: Date.current - 366.days)
         described_class.new(loan: loan, date: Date.current + 366.days).update_loan_aging_group!
        
         expect(loan.loan_aging_group).to eq loan_aging_group_6
         expect(loan.receivable_account.level_one_account_category).to eql office_loan_product_aging_group_6.level_one_account_category
         puts loan.number_of_days_past_due
      end
    end
  end
end
