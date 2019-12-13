require 'rails_helper'

module AccountCreators
  describe TimeDeposit do
    it '#create_accounts!' do
      office                            = create(:office)
      time_deposit_product              = create(:time_deposit_product)
      liability_account_category        = create(:liability_level_one_account_category, office: office)
      interest_expense_account_category = create(:expense_level_one_account_category, office: office)
      break_contract_account_category   = create(:revenue_level_one_account_category, office: office)

      create(:office_time_deposit_product, office: office, time_deposit_product: time_deposit_product, liability_account_category: liability_account_category, interest_expense_account_category: interest_expense_account_category, break_contract_account_category: break_contract_account_category)
      time_deposit = build(:time_deposit, office: office, time_deposit_product: time_deposit_product, liability_account_id: nil, interest_expense_account_id: nil, break_contract_account_id: nil)

      described_class.new(time_deposit: time_deposit).create_accounts!
      time_deposit.save!

      expect(time_deposit.liability_account).to_not eql nil
      expect(time_deposit.interest_expense_account).to_not eql nil
      expect(time_deposit.break_contract_account).to_not eql nil

      expect(office.accounts).to include time_deposit.liability_account
      expect(office.accounts).to include time_deposit.interest_expense_account
      expect(office.accounts).to include time_deposit.break_contract_account

      expect(liability_account_category.accounts).to include time_deposit.liability_account
      expect(interest_expense_account_category.accounts).to include time_deposit.interest_expense_account
      expect(break_contract_account_category.accounts).to include time_deposit.break_contract_account

    end
  end
end
