require 'rails_helper'

module AccountCreators
  describe Loan do
    it "#create_accounts" do
      loan = build(:loan, receivable_account_id: nil, interest_revenue_account_id: nil, penalty_revenue_account_id: nil)

      described_class.new(loan: loan).create_accounts!

      expect(loan.receivable_account).to_not eq nil
      expect(loan.interest_revenue_account).to_not eq nil
      expect(loan.penalty_revenue_account).to_not eq nil

    end
  end
end
