module TreasuryModule
  module CashAccounts
    class TotalCashAccountUpdater
      attr_reader :cart, :cash_account, :amount

      def initialize(cart:, cash_account:)
        @cart         = cart
        @cash_account = cash_account
        @amount       = @cart.voucher_amounts.find_by(account: @cash_account)
      end

      def update_amount!
        update_total_cash_amount
      end

      private

      def update_total_cash_amount
        total = cart.voucher_amounts.credit.total

        return if amount.blank?

        amount.update(amount: total)
      end
    end
  end
end