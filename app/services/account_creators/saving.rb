module AccountCreators
  class Saving
    attr_reader :saving, :office, :liability_account_category, :interest_expense_account_category, :saving_product

    def initialize(saving:)
      @saving                            = saving
      @saving_product                    = @saving.saving_product
      @office                            = @saving.office
      @liability_account_category        = @office.office_saving_products.find_by!(saving_product: @saving_product).liability_account_category
      @interest_expense_account_category = @office.office_saving_products.find_by!(saving_product: @saving_product).interest_expense_account_category
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
        account = office.accounts.liabilities.create!(

          name: "#{saving_product.name} - (#{saving.depositor_name} - #{saving.account_number}",
          code: saving.account_number,
          level_one_account_category: liability_account_category
        )
        saving.update(liability_account: account)
      end
    end

    def create_interest_expense_account
      if saving.interest_expense_account.blank?
        account = office.accounts.expenses.create!(
          name: "Interest Expense on Savings Deposits - (#{saving.depositor_name} - #{saving.account_number}",
          code: "INT-#{saving.account_number}",
          level_one_account_category: interest_expense_account_category
        )
        saving.update(interest_expense_account: account)

      end
    end
  end
end
