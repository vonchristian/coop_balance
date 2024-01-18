module AccountCreators
  class Saving
    attr_reader :saving, :office, :liability_ledger, :interest_expense_ledger, :saving_product

    def initialize(saving:)
      @saving                            = saving
      @saving_product                    = @saving.saving_product
      @office                            = @saving.office
      @liability_ledger        = @office.office_saving_products.find_by!(saving_product: @saving_product).liability_ledger
      @interest_expense_ledger = @office.office_saving_products.find_by!(saving_product: @saving_product).interest_expense_ledger
    end

    def create_accounts!
      ActiveRecord::Base.transaction do
        create_liability_account
        create_interest_expense_account
        add_accounts
      end
    end

    private

    def create_liability_account
      return if saving.liability_account_id.present?

      account = office.accounts.liabilities.create!(
        name: "#{saving_product.name} - (#{saving.depositor_name} - #{saving.account_number}",
        code: saving.account_number,
        ledger: liability_ledger
      )
      saving.update(liability_account: account)
    end

    def create_interest_expense_account
      return if saving.interest_expense_account_id.present?

      account = office.accounts.expenses.create!(
        name: "Interest Expense on Savings Deposits - (#{saving.depositor_name} - #{saving.account_number}",
        code: "INT-#{saving.account_number}",
        ledger: interest_expense_ledger
      )
      saving.update(interest_expense_account: account)
    end

    def add_accounts
      saving.accounts << saving.liability_account
      saving.accounts << saving.interest_expense_account
    end
  end
end
