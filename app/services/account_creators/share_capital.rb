module AccountCreators
  class ShareCapital
    attr_reader :share_capital, :share_capital_product, :office, :equity_ledger

    def initialize(share_capital:)
      @share_capital         = share_capital
      @office                = @share_capital.office
      @share_capital_product = @share_capital.share_capital_product
      @equity_ledger         = @office.office_share_capital_products.find_by!(share_capital_product: @share_capital_product).equity_ledger
    end

    def create_accounts!
      ApplicationRecord.transaction do
        create_equity_account
      end
    end

    private

    def create_equity_account
      return if share_capital.equity_account_id.present?

      account = office.accounts.equity.create!(
        name: "#{share_capital_product.name} - (#{share_capital.subscriber_name} - #{share_capital.account_number}",
        code: SecureRandom.uuid,
        ledger: equity_ledger
      )

      share_capital.update(share_capital_equity_account: account)
      share_capital.save!
    end
  end
end
