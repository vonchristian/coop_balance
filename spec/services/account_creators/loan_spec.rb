require 'rails_helper'

module AccountCreators
  describe Loan do
    it '#create_accounts!' do
      cooperative                       = create(:cooperative)
      member                            = create(:member)
      office                            = create(:office, cooperative: cooperative)
      receivable_ledger       = create(:asset_ledger)
      interest_revenue_ledger = create(:revenue_ledger)
      penalty_revenue_ledger  = create(:revenue_ledger)
      loan_product                      = create(:loan_product, name: 'Regular Loan', cooperative: cooperative)
      account_number                    = 'fad93d34-4c84-4f0d-b065-4ae2ad22094c'
      loan                              = build(:loan, receivable_account: nil, interest_revenue_account: nil, penalty_revenue_account: nil, borrower: member, loan_product: loan_product, account_number: account_number, office: office)
      office_loan_product               = create(:office_loan_product, office: office, loan_product: loan_product, interest_revenue_ledger: interest_revenue_ledger, penalty_revenue_ledger: penalty_revenue_ledger)
      loan_aging_group                  = create(:loan_aging_group, start_num: 0, end_num: 0, office: office)
      create(:office_loan_product_aging_group, office_loan_product: office_loan_product, loan_aging_group: loan_aging_group, receivable_ledger: receivable_ledger)

      described_class.new(loan: loan).create_accounts!

      loan.save!

      receivable_account       = loan.receivable_account
      interest_revenue_account = loan.interest_revenue_account
      penalty_revenue_account  = loan.penalty_revenue_account

      expect(receivable_account).not_to be_nil
      expect(interest_revenue_account).not_to be_nil
      expect(penalty_revenue_account).not_to be_nil

      expect(receivable_ledger.accounts).to include(receivable_account)
      expect(interest_revenue_ledger.accounts).to include(interest_revenue_account)
      expect(penalty_revenue_ledger.accounts).to include(penalty_revenue_account)

      expect(office.accounts.asset).to include(receivable_account)
      expect(office.accounts.revenue).to include(interest_revenue_account)
      expect(office.accounts.revenue).to include(penalty_revenue_account)

      expect(loan.accounts).to include(receivable_account)
      expect(loan.accounts).to include(interest_revenue_account)
      expect(loan.accounts).to include(penalty_revenue_account)
    end
  end
end
