require 'rails_helper'

module AccountCreators
  describe LoanApplication do
    it '#create_accounts!' do
      office              = create(:office)
      loan_product        = create(:loan_product)
      office_loan_product = create(:office_loan_product, office: office, loan_product: loan_product)
      loan_application    = build(:loan_application, office: office, loan_product: loan_product, receivable_account_id: nil, interest_revenue_account_id: nil)

      described_class.new(loan_application: loan_application).create_accounts!

      receivable_account       = loan_application.receivable_account
      interest_revenue_account = loan_application.interest_revenue_account

      expect(receivable_account).to_not eql nil
      expect(interest_revenue_account).to_not eql nil

      expect(office.accounts.assets).to include(receivable_account)
      expect(office.accounts.revenues).to include(interest_revenue_account)

      expect(office_loan_product.receivable_account_category.accounts).to include(receivable_account)
      expect(office_loan_product.interest_revenue_account_category.accounts).to include(interest_revenue_account)


    end
  end
end
