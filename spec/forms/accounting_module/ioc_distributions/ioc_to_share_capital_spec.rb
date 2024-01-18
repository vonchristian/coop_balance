require 'rails_helper'

module AccountingModule
  module IocDistributions
    describe IocToShareCapital, type: :model do
      describe 'attributes' do
        it { should respond_to(:cart_id) }
        it { should respond_to(:share_capital_id) }
        it { should respond_to(:employee_id) }
        it { should respond_to(:amount) }
      end

      describe 'validations' do
        it { should validate_presence_of :cart_id }
        it { should validate_presence_of :share_capital_id }
        it { should validate_presence_of :employee_id }
        it { should validate_presence_of :amount }
        it { should validate_numericality_of(:amount).is_greater_than(0) }
      end

      it '#process!' do
        bookkeeper = create(:bookkeeper)
        share_capital = create(:share_capital, office: bookkeeper.office)
        cart = create(:cart, employee: bookkeeper)

        described_class.new(
          employee_id: bookkeeper.id,
          share_capital_id: share_capital.id,
          cart_id: cart.id,
          amount: 100
        ).process!

        expect(cart.voucher_amounts.pluck(:account_id)).to include(share_capital.equity_account_id)
        expect(cart.voucher_amounts.where(account_id: share_capital.equity_account_id).total).to be 100
      end
    end
  end
end