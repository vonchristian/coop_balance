module ShareCapitals
  class CartPaymentFinder
    attr_reader :voucher_amount, :office

    def initialize(voucher_amount:, office:)
      @voucher_amount = voucher_amount
      @office = office 
    end 

    def share_capital
      office.share_capitals.find_by(equity_account_id: voucher_amount.account_id)
    end 
  end 
end 