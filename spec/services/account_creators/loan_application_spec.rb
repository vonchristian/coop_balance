require 'rails_helper'

module AccountCreators
  describe LoanApplication do 
    it '#create_accounts!' do 
      loan_application = build(:loan_application, receivable_account_id: nil, interest_revenue_account_id: nil)

      described_class.new(loan_application: loan_application).create_accounts!

      expect(loan_application.receivable_account).to_not eql nil 
      expect(loan_application.interest_revenue_account).to_not eql nil 
    end
  end
end