require 'rails_helper'

module AccountCreators
  describe Loan do
    it '#create_accounts!' do
      cooperative                       = create(:cooperative)
      member                            = create(:member)
      office                            = create(:office, cooperative: cooperative)
      receivable_account_category       = create(:asset_level_one_account_category, office: office)
      interest_revenue_account_category = create(:revenue_level_one_account_category, office: office)
      penalty_revenue_account_category  = create(:revenue_level_one_account_category, office: office)
      loan_product                      = create(:loan_product, name: 'Regular Loan', cooperative: cooperative)
      account_number                    = 'fad93d34-4c84-4f0d-b065-4ae2ad22094c'
      loan                              = build(:loan, receivable_account: nil, interest_revenue_account: nil, penalty_revenue_account: nil,  borrower: member, loan_product: loan_product, account_number: account_number, office: office)
      create(:office_loan_product, office: office, loan_product: loan_product, receivable_account_category: receivable_account_category, interest_revenue_account_category: interest_revenue_account_category, penalty_revenue_account_category: penalty_revenue_account_category)

      AccountCreators::Loan.new(loan: loan, loan_product: loan_product).create_accounts!
      loan.save!

      receivable_account       = AccountingModule::Account.find_by(name: "Loans Receivable - #{loan.loan_product_name} #{loan.account_number}")
      interest_revenue_account = AccountingModule::Account.find_by(name: "Interest Income from Loans - #{loan.loan_product_name} #{loan.account_number}")
      penalty_revenue_account  = AccountingModule::Account.find_by(name: "Fines, Penalties, and Surcharges - #{loan.loan_product_name} #{loan.account_number}" )

      expect(loan.receivable_account).to eq(receivable_account)
      expect(loan.interest_revenue_account).to eq(interest_revenue_account)
      expect(loan.penalty_revenue_account).to eq(penalty_revenue_account)

      expect(receivable_account_category.accounts).to include(receivable_account)
      expect(interest_revenue_account_category.accounts).to include(interest_revenue_account)
      expect(penalty_revenue_account_category.accounts).to include(penalty_revenue_account)

      expect(office.accounts).to include(receivable_account)
      expect(office.accounts).to include(interest_revenue_account)
      expect(office.accounts).to include(penalty_revenue_account)

      expect(loan.accounts).to include(receivable_account)
      expect(loan.accounts).to include(interest_revenue_account)
      expect(loan.accounts).to include(penalty_revenue_account)


    end
  end
end
