require 'rails_helper'

module ShareCapitals
  describe BalanceTransferVoucher, type: :model do
    describe 'validations' do
      it { should validate_presence_of :cart_id }
      it { should validate_presence_of :date }
      it { should validate_presence_of :reference_number }
      it { should validate_presence_of :description }
      it { should validate_presence_of :employee_id }
      it { should validate_presence_of :account_number }
      it { should validate_presence_of :share_capital_id }
    end

    it '#process!' do
      bookkeeper      = create(:bookkeeper)
      share_capital_1 = create(:share_capital, office: bookkeeper.office)
      share_capital_2 = create(:share_capital, office: bookkeeper.office)
      account_number  = '989e3764-0c67-4cdf-9490-aa3b8dcbd5a5'

      cart = create(:cart, employee: bookkeeper)
      credit_amount = cart.voucher_amounts.credit.create!(amount: 100, account: share_capital_1.share_capital_equity_account)
      debit_amount  = cart.voucher_amounts.debit.create!(amount: 100, account: share_capital_2.share_capital_equity_account)

      described_class.new(
        cart_id: cart.id,
        employee_id: bookkeeper.id,
        account_number: account_number,
        date: Date.current,
        reference_number: 'test',
        description: 'balance transfer',
        share_capital_id: share_capital_1.id
      ).process!

      voucher = bookkeeper.office.vouchers.find_by(account_number: account_number)

      expect(voucher).not_to eql nil
      expect(voucher.voucher_amounts.credit).to include(credit_amount)
      expect(voucher.voucher_amounts.debit).to include(debit_amount)

      expect(cart.voucher_amounts.credit).not_to include(credit_amount)
      expect(cart.voucher_amounts.debit).not_to include(debit_amount)
    end
  end
end
