module AccountCreators
  class Saving
    attr_reader :saving

    def initialize(saving:)
      @saving = saving
    end

    def create_accounts!
      ActiveRecord::Base.transaction do
        create_liability_account
        create_interest_expense_account
      end
    end

    private

    def create_liability_account
      if saving.liability_account.blank?
        account = AccountingModule::Liability.first_or_create!(

          name: "#{saving.saving_product_name} - #{saving.account_number}",
          code: saving.account_number
        )
        saving.update(liability_account: account)
      end
    end

    def create_interest_expense_account
      if saving.interest_expense_account.blank?
        account = AccountingModule::Expense.first_or_create!(
          name: "Interest Expense on Savings - #{saving.saving_product_name} - #{saving.account_number}",
          code: "INT-#{saving.account_number}"
        )
        saving.update(interest_expense_account: account)

      end
    end
  end
end
