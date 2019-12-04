module AccountCreators
  class SavingsAccountApplication
    attr_reader :savings_account_application, :saving_product

    def initialize(savings_account_application:)
      @savings_account_application = savings_account_application
      @saving_product              = @savings_account_application.saving_product
    end

    def create_accounts!
      create_liability_account
    end

    private
    def create_liability_account
      if savings_account_application.liability_account.blank?
        account = AccountingModule::Liability.create!(
          name: "#{saving_product.name} - #{savings_account_application.account_number}",
          code: savings_account_application.account_number
        )
        savings_account_application.update(liability_account: account)
      end
    end
  end
end
