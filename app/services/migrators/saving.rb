module Migrators
  class Saving
    attr_reader :saving, :saving_product, :account, :interest_expense_account

    def initialize(saving:)
      @saving                   = saving
      @saving_product           = @saving.saving_product
      @account                  = @saving_product.account
      @interest_expense_account = @saving_product.interest_expense_account
    end

    def migrate_entries!
      migrate_liability_account_entries
      migrate_interest_expense_account_entries
    end

    private
    def migrate_liability_account_entries
      account.amounts.where(commercial_document_id: saving.id).each do |amount|
        amount.update!(account: saving.liability_account)
      end
    end

    def migrate_interest_expense_account_entries
      interest_expense_account.amounts.where(commercial_document_id: saving.id).each do |amount|
        amount.update!(account: saving.interest_expense_account)
      end
    end
  end
end
