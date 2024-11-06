module AccountCreators
  class SavingsAccountApplication
    attr_reader :savings_account_application, :saving_product, :office, :liability_ledger

    def initialize(savings_account_application:)
      @savings_account_application = savings_account_application
      @office                      = @savings_account_application.office
      @saving_product              = @savings_account_application.saving_product
      @liability_ledger            = @office.office_saving_products.find_by(saving_product: @saving_product).liability_ledger
    end

    def create_accounts!
      create_liability_account
    end

    private

    def create_liability_account
      return if savings_account_application.liability_account.present?

      account = office.accounts.liability.create!(
        name: "#{saving_product.name} - #{savings_account_application.account_number}",
        code: SecureRandom.uuid,
        ledger: liability_ledger
      )
      savings_account_application.update(liability_account: account)
    end
  end
end
