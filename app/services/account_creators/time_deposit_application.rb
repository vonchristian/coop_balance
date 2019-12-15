module AccountCreators
  class TimeDepositApplication
    attr_reader :time_deposit_application, :time_deposit_product, :office, :liability_account_category

    def initialize(time_deposit_application:)
      @time_deposit_application   = time_deposit_application
      @office                     = @time_deposit_application.office
      @time_deposit_product       = @time_deposit_application.time_deposit_product
      @liability_account_category = @office.office_time_deposit_products.find_by(time_deposit_product: @time_deposit_product).liability_account_category
    end


    def create_accounts!
      create_liability_account
    end

    private

    def create_liability_account
      if time_deposit_application.liability_account.blank?
        account = office.accounts.liabilities.create!(
          name:                       "#{time_deposit_product.name} - #{time_deposit_application.account_number}",
          code:                       SecureRandom.uuid,
          level_one_account_category: liability_account_category
        )
        time_deposit_application.update(liability_account: account)
      end
    end
  end
end
