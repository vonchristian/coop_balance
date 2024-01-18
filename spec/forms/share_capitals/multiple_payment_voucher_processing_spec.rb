require 'rails_helper'

module ShareCapitals
  describe MultiplePaymentVoucherProcessing, type: :model do
    describe 'validations' do
      it { should validate_presence_of :date }
      it { should validate_presence_of :reference_number }
      it { should validate_presence_of :description }
      it { should validate_presence_of :cart_id }
      it { should validate_presence_of :employee_id }
      it { should validate_presence_of :cash_account_id }
      it { should validate_presence_of :account_number }
    end

    it '#process!' do
      teller         = create(:teller)
      office         = teller.office
      cash_account   = create(:asset)
      cart           = create(:cart, employee: teller)
      credit         = create(:voucher_amount, amount_type: 'credit', amount: 1000, cart: cart)
      account_number = 'c6b58e9e-3ea2-4197-a7f4-85b7eecc858d'
      teller.cash_accounts << cash_account

      described_class.new(
        cart_id: cart.id,
        date: Date.current,
        reference_number: 'r3123',
        description: 'test',
        employee_id: teller.id,
        cash_account_id: cash_account.id,
        account_number: account_number
      )
                     .process!

      voucher = office.vouchers.find_by!(account_number: account_number)

      expect(voucher).not_to be_nil
      expect(voucher.voucher_amounts.credit).to include(credit)
      expect(voucher.voucher_amounts.debit.pluck(:account_id)).to include(cash_account.id)
      expect(voucher.voucher_amounts.credit.total).to eql voucher.voucher_amounts.debit.total
      expect(cart.voucher_amounts).not_to include(credit)
    end
  end
end