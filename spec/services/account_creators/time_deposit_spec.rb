require 'rails_helper'

module AccountCreators
  describe TimeDeposit do
    it '#create_accounts!' do
      time_deposit = build(:time_deposit, liability_account_id: nil, interest_expense_account_id: nil, break_contract_account_id: nil)

      described_class.new(time_deposit: time_deposit).create_accounts!
      time_deposit.save!

      expect(time_deposit.liability_account).to_not eql nil
      expect(time_deposit.interest_expense_account).to_not eql nil
      expect(time_deposit.break_contract_account).to_not eql nil

    end
  end
end
