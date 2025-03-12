require 'rails_helper'

module AccountingModule
  module IocDistributions
    describe IocToLoan, type: :model do
      describe 'attributes' do
        it { should respond_to(:loan_id) }
        it { should respond_to(:cart_id) }
        it { should respond_to(:employee_id) }
        it { should respond_to(:principal_amount) }
        it { should respond_to(:interest_amount) }
        it { should respond_to(:penalty_amount) }
      end

      describe 'validations' do
        it { should validate_presence_of :cart_id }
        it { should validate_presence_of :loan_id }
        it { should validate_presence_of :employee_id }
        it { should validate_presence_of :principal_amount }
        it { should validate_presence_of :interest_amount }
        it { should validate_presence_of :penalty_amount }
        it { should validate_numericality_of(:principal_amount).is_greater_than_or_equal_to(0) }
        it { should validate_numericality_of(:interest_amount).is_greater_than_or_equal_to(0) }
        it { should validate_numericality_of(:penalty_amount).is_greater_than_or_equal_to(0) }
      end

      it '#process' do
        bookkeeper = create(:bookkeeper)
        loan       = create(:loan, office: bookkeeper.office)
        cart       = create(:cart, employee: bookkeeper)

        described_class.new(
          loan_id: loan.id,
          cart_id: cart.id,
          employee_id: bookkeeper.id,
          principal_amount: 100,
          interest_amount: 200,
          penalty_amount: 300
        ).process!

        expect(cart.voucher_amounts.pluck(:account_id)).to include(loan.receivable_account_id)
        expect(cart.voucher_amounts.pluck(:account_id)).to include(loan.interest_revenue_account_id)
        expect(cart.voucher_amounts.pluck(:account_id)).to include(loan.penalty_revenue_account_id)
        expect(cart.voucher_amounts.where(account_id: loan.receivable_account_id).total).to be 100
        expect(cart.voucher_amounts.where(account_id: loan.interest_revenue_account_id).total).to be 200
        expect(cart.voucher_amounts.where(account_id: loan.penalty_revenue_account_id).total).to be 300
      end
    end
  end
end
