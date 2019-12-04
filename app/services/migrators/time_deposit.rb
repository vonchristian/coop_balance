module Migrators
  class TimeDeposit
    attr_reader :time_deposit, :time_deposit_product, :liability_account, :interest_expense_account, :break_contract_account

    def initialize(time_deposit:)
      @time_deposit             = time_deposit
      @time_deposit_product     = @time_deposit.time_deposit_product
      @liability_account        = @time_deposit_product.liability_account
      @interest_expense_account = @time_deposit_product.interest_expense_account
      @break_contract_account   = @time_deposit_product.break_contract_account

    end

    def migrate_entries!
      migrate_liability_account_entries
      migrate_interest_expense_account_entries
      migrate_break_contract_entries
    end

    private
    def migrate_liability_account_entries
      liability_account.amounts.where(commercial_document_id: time_deposit.id).each do |amount|
        amount.update!(account: time_deposit.liability_account)
      end
    end

    def migrate_interest_expense_account_entries
      interest_expense_account.amounts.where(commercial_document_id: time_deposit.id).each do |amount|
        amount.update!(account: time_deposit.interest_expense_account)
      end
    end

    def migrate_break_contract_entries
      break_contract_account.amounts.where(commercial_document_id: time_deposit.id).each do |amount|
        amount.update!(account: time_deposit.break_contract_account)
      end
    end
  end
end
