require 'rails_helper'

module LoansModule
  module Loans
    describe PaymentFromSaving, type: :model do
      describe 'validations' do
        it { is_expected.to validate_presence_of :amount }
        it { is_expected.to validate_numericality_of(:amount).is_greater_than(0.1) }
        it { is_expected.to validate_presence_of :loan_id }
        it { is_expected.to validate_presence_of :saving_id }
        it { is_expected.to validate_presence_of :cart_id }
        it { is_expected.to validate_presence_of :employee_id }
      end

      it '#process' do
        cart       = create(:cart)
        bookkeeper = create(:bookkeeper)
        office     = bookkeeper.office
        saving     = create(:saving, office: office)
        loan       = create(:loan, office: office)

        described_class.new(
          amount: 100,
          employee_id: bookkeeper.id,
          saving_id:   saving.id,
          loan_id: loan.id,
          cart_id: cart.id
        ).process!

        expect(cart.voucher_amounts.credit.pluck(:account_id)).to include(loan.receivable_account_id)
        expect(cart.voucher_amounts.debit.pluck(:account_id)).to include(saving.liability_account_id)
        expect(cart.voucher_amounts.debit.total).to eq 100

      end
    end
  end
end
