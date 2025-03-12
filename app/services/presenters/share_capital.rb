module Presenters
  class ShareCapital
    attr_reader :share_capital, :entry, :account

    def initialize(share_capital:, entry:)
      @share_capital  = share_capital
      @entry          = entry
      @account        = @share_capital.share_capital_equity_account
    end

    def chevron
      if entry.credit_amounts.accounts.include?(account)
        "down"
      else
        "up"
      end
    end

    def text_color
      if entry.credit_amounts.accounts.include?(account)
        "success"
      else
        "danger"
      end
    end

    def plus_or_minus_icon
      if entry.credit_amounts.accounts.include?(account)
        "plus"
      else
        "minus"
      end
    end
  end
end
