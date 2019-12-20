module AccountCreators
  class ShareCapitalApplication
    attr_reader :share_capital_application, :office, :equity_account_category

    def initialize(share_capital_application:)
      @share_capital_application = share_capital_application
      @office = @share_capital_application.office 
      @share_capital_product = @share_capital_application.share_capital_product
      @equity_account_category = @office.office_share_capital_products.find_by(share_capital_product: @share_capital_product).equity_account_category
    end
    
    def create_accounts!
      create_equity_account
    end

    private
    def create_equity_account
      if share_capital_application.equity_account.blank?
        account = AccountingModule::Equity.create!(
          name: "#{share_capital_application.share_capital_product_name} - #{share_capital_application.account_number}",
          code: share_capital_application.account_number,
          level_one_account_category: equity_account_category
        )
        share_capital_application.update(equity_account: account)
      end
    end
  end
end
