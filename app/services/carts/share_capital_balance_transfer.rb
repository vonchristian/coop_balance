module Carts
  class ShareCapitalBalanceTransfer
    attr_reader :cart, :office, :voucher_amount

    def initialize(cart:, voucher_amount:)
      @cart           = cart
      @voucher_amount = voucher_amount
      @employee       = @cart.employee
      @office         = @employee.office
    end

    def destination_share_capital
      office.share_capitals.find_by!(equity_account_id: voucher_amount.account_id)
    end
  end
end