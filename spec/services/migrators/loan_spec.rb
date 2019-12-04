require 'rails_helper'

module Migrators
  describe Loan do
    it '#migrate_entries' do
      asset         = create(:asset)
      teller        = create(:teller)
      loan          = create(:loan)
      entry         = build(:entry, recorder: teller, office: teller.office, cooperative: teller.cooperative, commercial_document: loan)
      entry.credit_amounts.build(account: asset, amount: 85_000, commercial_document: loan)
      entry.credit_amounts.build(account: loan.loan_product_interest_revenue_account, amount: 5_000, commercial_document: loan)
      entry.credit_amounts.build(account: loan.loan_product_penalty_revenue_account, amount: 5_000, commercial_document: loan)
      entry.credit_amounts.build(account: loan.loan_product_accrued_income_account, amount: 5_000, commercial_document: loan)

      entry.debit_amounts.build(account: loan.loan_product_current_account, amount: 100_000, commercial_document: loan)
      entry.save!

      expect(loan.receivable_account.balance).to eql 0
      expect(loan.interest_revenue_account.balance).to eql 0
      expect(loan.penalty_revenue_account.balance).to eql 0
      expect(loan.accrued_income_account.balance).to eql 0


      described_class.new(loan: loan).migrate_entries!

      expect(loan.receivable_account.balance).to eql 100_000
      expect(loan.interest_revenue_account.balance).to eql 5_000
      expect(loan.penalty_revenue_account.balance).to eql 5_000
      expect(loan.accrued_income_account.balance).to eql -5_000

    end
  end
end
