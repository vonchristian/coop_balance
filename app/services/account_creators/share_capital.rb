module AccountCreators
  class ShareCapital
    attr_reader :share_capital, :share_capital_product, :office, :equity_account_category, :interest_payable_account_category

    def initialize(share_capital:)
      @share_capital           = share_capital
      @office                  = @share_capital.office
      @share_capital_product   = @share_capital.share_capital_product
      @equity_account_category = @office.office_share_capital_products.find_by!(share_capital_product: @share_capital_product).equity_account_category
    end

    def create_accounts!
      ApplicationRecord.transaction do 
        create_equity_account
        add_accounts
      end 
    end

    private 

    def create_equity_account
      if share_capital.share_capital_equity_account.blank?
         account = office.accounts.equities.create!(
          name:                       "#{share_capital_product.name} - (#{share_capital.subscriber_name} - #{share_capital.account_number}",
          code:                       SecureRandom.uuid,
          level_one_account_category: equity_account_category
        )
        share_capital.update(share_capital_equity_account: account)
      end
    end
    def add_accounts
      share_capital.accounts << share_capital.share_capital_equity_account
    end
  end
end
