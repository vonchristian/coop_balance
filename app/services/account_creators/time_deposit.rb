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
        liab_account = AccountingModule::Liability.where(

          name: "#{time_deposit.time_deposit_product_name} - #{time_deposit.account_number}",
          code: time_deposit.account_number
        ).last
        time_deposit.update(liability_account: liab_account)
      end
    end

    def create_interest_expense_account
      if time_deposit.interest_expense_account.blank?
        exp_account = AccountingModule::Expense.where(
          name: "Interest Expense on Time Deposits - #{time_deposit.time_deposit_product_name} - #{time_deposit.account_number}",
          code: "INT-#{time_deposit.account_number}"
        ).last
        time_deposit.update(interest_expense_account: exp_account)

      end
    end

    def create_break_contract_account
      if time_deposit.break_contract_account.blank?
        brk_account = AccountingModule::Expense.where(
          name: "Break Contract Fees - #{time_deposit.time_deposit_product_name} - #{time_deposit.account_number}",
          code: "BRK-#{time_deposit.account_number}"
        ).last
        time_deposit.update(break_contract_account: brk_account)

      end
    end
  end
end
