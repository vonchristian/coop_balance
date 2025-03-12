require 'rails_helper'

module TreasuryModule
  module CashAccounts
    describe TotalCashAccountUpdater do
      it '#update_amount!' do
        cash = create(:asset)
        cart = create(:cart)
        create(:credit_voucher_amount, cart: cart, amount: 100)
        voucher_amount_2 = create(:credit_voucher_amount, cart: cart, amount: 100)

        create(:debit_voucher_amount, cart: cart, account: cash, amount: 200)

        expect(cart.voucher_amounts.credit.total).to be 200

        voucher_amount_2.destroy

        described_class.new(cart: cart, cash_account: cash).update_amount!

        expect(cart.voucher_amounts.credit.total).to be 100
      end
    end
  end
end
