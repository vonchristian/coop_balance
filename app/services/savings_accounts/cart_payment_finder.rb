module SavingsAccounts
  class CartPaymentFinder
    attr_reader :voucher_amount, :office

    def initialize(voucher_amount:, office:)
      @voucher_amount = voucher_amount
      @office         = office
    end

    def savings_account
      office.savings.find_by(liability_account_id: voucher_amount.account_id)
    end
  end
end