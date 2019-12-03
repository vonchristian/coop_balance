module AccountCreators
  class ShareCapitalApplication
    attr_reader :share_capital_application

    def initialize(share_capital_application:)
      @share_capital_application = share_capital_application
    end
    
    def create_accounts!
      create_equity_account
    end

    private
    def create_equity_account
      if share_capital_application.equity_account.blank?
        account = AccountingModule::Equity.create!(
          name: "#{share_capital_application.share_capital_product_name} - #{share_capital_application.account_number}",
          code: share_capital_application.account_number
        )
        share_capital_application.update(equity_account: account)
      end
    end
  end
end
