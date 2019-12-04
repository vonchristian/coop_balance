module AccountCreators
  class TimeDepositApplication
    attr_reader :time_deposit_application, :time_deposit_product

    def initialize(time_deposit_application:)
      @time_deposit_application = time_deposit_application
      @time_deposit_product     = @time_deposit_application.time_deposit_product
    end

    def create_accounts!
      create_liability_account 
    end

    private 
    def create_liability_account
      if time_deposit_application.liability_account.blank?
        account = AccountingModule::Liability.create!(
          name: "#{time_deposit_product.name} - #{time_deposit_application.account_number}",
          code: time_deposit_application.account_number
        )
        time_deposit_application.update(liability_account: account)
      end
    end
  end
end