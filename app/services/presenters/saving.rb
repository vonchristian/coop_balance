module Presenters
  class Saving
    attr_reader :saving, :entry, :liability_account

    def initialize(saving:, entry:)
      @saving            = saving
      @entry             = entry
      @liability_account = @saving.liability_account
    end

    def chevron
      if entry.credit_amounts.accounts.include?(liability_account)
        'down'
      else
        'up'
      end
    end
    def text_color
      if entry.credit_amounts.accounts.include?(liability_account)
        'success'
      else
        'danger'
      end
    end
    def plus_or_minus_icon
      if entry.credit_amounts.accounts.include?(liability_account)
        'plus'
      else
        'minus'
      end
    end
  end
end
