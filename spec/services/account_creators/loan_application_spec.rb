require 'rails_helper'

module AccountCreators
  describe LoanApplication do
    it '#create_accounts!' do
      office                          = create(:office)
      loan_product                    = create(:loan_product)
      loan_aging_group                = create(:loan_aging_group, start_num: 0, end_num: 0, office: office)
      office_loan_product             = create(:office_loan_product, office: office, loan_product: loan_product)
      office_loan_product_aging_group = create(:office_loan_product_aging_group, office_loan_product: office_loan_product, loan_aging_group: loan_aging_group)
      loan_application                = build(:loan_application, office: office, loan_product: loan_product, receivable_account_id: nil, interest_revenue_account_id: nil)

      described_class.new(loan_application: loan_application).create_accounts!

      receivable_account       = loan_application.receivable_account
      interest_revenue_account = loan_application.interest_revenue_account

      expect(receivable_account).not_to eql nil
      expect(interest_revenue_account).not_to eql nil

      expect(office.accounts.assets).to include(receivable_account)
      expect(office.accounts.revenues).to include(interest_revenue_account)

      expect(office_loan_product_aging_group.receivable_ledger.accounts).to include(receivable_account)
      expect(office_loan_product.interest_revenue_ledger.accounts).to include(interest_revenue_account)
    end
  end
end
