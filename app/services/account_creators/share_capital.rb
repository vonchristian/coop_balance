module AccountCreators
  class ShareCapital
    attr_reader :share_capital

    def initialize(share_capital:)
      @share_capital = share_capital
    end

    def create_accounts!
      ActiveRecord::Base.transaction do
        create_share_capital_equity_account
        create_interest_on_capital_account
      end
    end

    def create_share_capital_equity_account
      if share_capital.share_capital_equity_account.blank?
        account = AccountingModule::Equity.create!(

          name: "#{share_capital.share_capital_product_name} - #{share_capital.account_number}",
          code: share_capital.account_number
        )
        share_capital.update(share_capital_equity_account: account)
      end
    end

    def create_interest_on_capital_account
      if share_capital.interest_on_capital_account.blank?
        account = AccountingModule::Equity.create!(

          name: "Interest on Share Capital #{share_capital.share_capital_product_name} - #{share_capital.account_number}",
          code: share_capital.account_number
        )
        share_capital.update(interest_on_capital_account: account)

      end
    end
  end
end
