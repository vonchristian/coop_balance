require 'rails_helper'

module LoansModule
  module Loans
    describe PaymentFromSavingVoucher, type: :model do
      describe 'validations' do
        it  { is_expected.to validate_presence_of :date }
        it  { is_expected.to validate_presence_of :description }
        it  { is_expected.to validate_presence_of :reference_number }
        it  { is_expected.to validate_presence_of :cart_id }
        it  { is_expected.to validate_presence_of :employee_id }
        it  { is_expected.to validate_presence_of :loan_id }
        it  { is_expected.to validate_presence_of :account_number }
      end

      it '#process' do
        bookkeeper = create(:bookkeeper)
        office     = bookkeeper.office
        cart       = create(:cart, employee: bookkeeper)
        loan       = create(:loan, office: office)
        saving     = create(:saving)
        cart.voucher_amounts.debit.create!(amount: 100, account: saving.liability_account)
        cart.voucher_amounts.credit.create!(amount: 100, account: loan.receivable_account)
        account_number = "9eeed1d8-7898-466a-875b-2d9f9c8c2877"

        described_class.new(
          cart_id:           cart.id,
          date:              Date.current,
          description:      'payment',
          reference_number: '01',
          employee_id:      bookkeeper.id,
          loan_id:          loan.id,
          account_number:   account_number
        ).process!

        voucher = office.vouchers.find_by(account_number: account_number)

        expect(voucher.voucher_amounts.ids).to eq(cart.voucher_amounts.ids)
        expect(voucher.reference_number).to eq '01'
        expect(voucher.description).to eq 'payment'
        expect(voucher.date.to_date).to eq Date.current.to_date
        expect(voucher.account_number).to eq account_number
        expect(voucher.preparer).to eq bookkeeper
        expect(voucher.payee).to eq loan.borrower
      end
    end
  end
end
