require 'rails_helper'

module LoansModule
  module Loans 
    describe PaidAtUpdater, type: :model do
      it 'update_paid_at!' do 
        teller       = create(:teller)
        cash_account = create(:asset)
        loan         = create(:loan, paid_at: nil)
        teller.cash_accounts << cash_account
        
        expect(loan.paid?).to eql false 
       
        #disbursement 
        disbursement = build(:entry, entry_date: Date.current)
        disbursement.credit_amounts.build(amount: 10_000, account: cash_account)
        disbursement.debit_amounts.build(amount: 10_000, account: loan.receivable_account)
        disbursement.save!

        described_class.new(loan: loan, date: Date.current).update_paid_at!
        
        expect(loan.paid_at).to eql nil 

        #payment 
        payment = build(:entry, entry_date: Date.current.next_month)
        payment.debit_amounts.build(amount: 10_000, account: cash_account)
        payment.credit_amounts.build(amount: 10_000, account: loan.receivable_account)
        payment.save!

        described_class.new(loan: loan, date: Date.current.next_month).update_paid_at!

        expect(loan.paid_at.to_date).to eql Date.current.next_month.to_date
      end  
    end 
  end 
end 