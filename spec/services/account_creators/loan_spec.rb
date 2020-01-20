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
      office_loan_product               = create(:office_loan_product, office: office, loan_product: loan_product, interest_revenue_account_category: interest_revenue_account_category, penalty_revenue_account_category: penalty_revenue_account_category)
      loan_aging_group                  = create(:loan_aging_group, start_num: 0, end_num: 0, office: office)
      office_loan_product_aging_goup    = create(:office_loan_product_aging_group, office_loan_product: office_loan_product, loan_aging_group: loan_aging_group, level_one_account_category: receivable_account_category)

      AccountCreators::Loan.new(loan: loan).create_accounts!

      loan.save!

      receivable_account       = loan.receivable_account
      interest_revenue_account = loan.interest_revenue_account
      penalty_revenue_account  = loan.penalty_revenue_account

      expect(receivable_account).to_not eq nil
      expect(interest_revenue_account).to_not eq nil
      expect(penalty_revenue_account).to_not eq nil

      expect(receivable_account_category.accounts).to include(receivable_account)
      expect(interest_revenue_account_category.accounts).to include(interest_revenue_account)
      expect(penalty_revenue_account_category.accounts).to include(penalty_revenue_account)

      expect(office.accounts.assets).to include(receivable_account)
      expect(office.accounts.revenues).to include(interest_revenue_account)
      expect(office.accounts.revenues).to include(penalty_revenue_account)

      expect(loan.accounts).to include(receivable_account)
      expect(loan.accounts).to include(interest_revenue_account)
      expect(loan.accounts).to include(penalty_revenue_account)


    end
  end
end
