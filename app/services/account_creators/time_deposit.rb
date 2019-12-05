module AccountCreators
  class TimeDeposit
    attr_reader :time_deposit

    def initialize(time_deposit:)
      @time_deposit = time_deposit
    end

    def create_accounts!
      create_liability_account
      create_interest_expense_account
      create_break_contract_account
    end

    private
    def create_liability_account
      if time_deposit.liability_account.blank?
        account = AccountingModule::Liability.create!(

          name: "#{time_deposit.time_deposit_product_name} - #{time_deposit.account_number}",
          code: time_deposit.account_number
        )
        time_deposit.update(liability_account: account)
      end
    end

    def create_interest_expense_account
      if time_deposit.interest_expense_account.blank?
        account = AccountingModule::Expense.create!(
          name: "Interest Expense on Time Deposits - #{time_deposit.time_deposit_product_name} - #{time_deposit.account_number}",
          code: "INT-#{time_deposit.account_number}"
        )
        time_deposit.update(interest_expense_account: account)

      end
    end

    def create_break_contract_account
      if time_deposit.break_contract_account.blank?
        account = AccountingModule::Expense.create!(
          name: "Break Contract Fees - #{time_deposit.time_deposit_product_name} - #{time_deposit.account_number}",
          code: "BRK-#{time_deposit.account_number}"
        )
        time_deposit.update(break_contract_account: account)

      end
    end
  end
end