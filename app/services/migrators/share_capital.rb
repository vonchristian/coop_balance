module Migrators
  class ShareCapital
    attr_reader :share_capital, :share_capital_product, :equity_account

    def initialize(share_capital:)
      @share_capital         = share_capital
      @share_capital_product = @share_capital.share_capital_product
      @equity_account        = @share_capital_product.equity_account
    end

    def migrate_entries!
      equity_account.amounts.where(commercial_document_id: share_capital.id).each do |amount|
        amount.update!(account: share_capital.share_capital_equity_account)
      end
    end
  end
end
