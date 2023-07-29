module AccountCreators
  class ShareCapitalApplication
    attr_reader :share_capital_application, :office, :equity_ledger

    def initialize(share_capital_application:)
      @share_capital_application = share_capital_application
      @office                    = @share_capital_application.office 
      @share_capital_product     = @share_capital_application.share_capital_product
      @equity_ledger             = @office.office_share_capital_products.find_by(share_capital_product: @share_capital_product).equity_ledger
    end
    
    def create_accounts!
      ApplicationRecord.transaction do 
        create_equity_account
      end 
    end

    private

    def create_equity_account
      if share_capital_application.equity_account_id.blank?
        account = office.accounts.equities.create!(
          name:   "#{share_capital_application.share_capital_product_name} - #{share_capital_application.account_number}",
          code:   share_capital_application.account_number,
          ledger: equity_ledger
        )
        share_capital_application.update(equity_account: account)
      end
    end
  end
end
