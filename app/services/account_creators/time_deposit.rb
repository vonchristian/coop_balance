module AccountCreators
  class TimeDeposit
    attr_reader :time_deposit, :office, :liability_ledger, :interest_expense_ledger, :break_contract_revenue_ledger

    def initialize(time_deposit:)
      @time_deposit                      = time_deposit
      @office                            = @time_deposit.office
      @time_deposit_product              = @time_deposit.time_deposit_product
      @liability_ledger        = @office.office_time_deposit_products.find_by(time_deposit_product_id: @time_deposit_product.id).liability_ledger
      @interest_expense_ledger = @office.office_time_deposit_products.find_by(time_deposit_product_id: @time_deposit_product.id).interest_expense_ledger
      @break_contract_revenue_ledger   = @office.office_time_deposit_products.find_by(time_deposit_product_id: @time_deposit_product.id).break_contract_revenue_ledger

    end

    def create_accounts!
      create_liability_account
      create_interest_expense_account
      create_break_contract_account
    end

    private
    def create_liability_account
      if time_deposit.liability_account.blank?
        account = office.accounts.liabilities.create!(
          name: "#{time_deposit.time_deposit_product_name} - #{time_deposit.account_number}",
          code: time_deposit.account_number,
          ledger: liability_ledger
        )
        time_deposit.update(liability_account: account)
      end
    end

    def create_interest_expense_account
      if time_deposit.interest_expense_account.blank?
        exp_account = office.accounts.expenses.create!(
          name: "Interest Expense on Time Deposits - #{time_deposit.time_deposit_product_name} - #{time_deposit.account_number}",
          code: SecureRandom.uuid,
          ledger: interest_expense_ledger
        )
        time_deposit.update(interest_expense_account: exp_account)

      end
    end

    def create_break_contract_account
      if time_deposit.break_contract_account.blank?
        brk_account = office.accounts.revenues.create!(
          name: "Break Contract Fees - #{time_deposit.time_deposit_product_name} - #{time_deposit.account_number}",
          code: SecureRandom.uuid,
          ledger: break_contract_revenue_ledger
        )
        time_deposit.update(break_contract_account: brk_account)
      end
    end
  end
end
