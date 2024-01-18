module Loans
  class CartPaymentFinder
    attr_reader :cart

    def initialize(args)
      @cart = args.fetch(:cart)
    end

    def principal(voucher_amount)
      cart.voucher_amounts.find(voucher_amount.id).amount
    end

    def interest(voucher_amount)
      cart.voucher_amounts.find(voucher_amount.id).amount
    end
  end
end
