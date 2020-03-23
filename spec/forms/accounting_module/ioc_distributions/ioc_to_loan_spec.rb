require 'rails_helper'

module AccountingModule
  module IocDistributions
    describe IocToLoan, type: :model do 
      describe "attributes" do 
        it { is_expected.to respond_to(:loan_id) }
        it { is_expected.to respond_to(:cart_id) }
        it { is_expected.to respond_to(:employee_id) }
        it { is_expected.to respond_to(:principal_amount) }
        it { is_expected.to respond_to(:interest_amount) }
        it { is_expected.to respond_to(:penalty_amount) }
      end 
      describe "validations" do 
        it { is_expected.to validate_presence_of :cart_id }
        it { is_expected.to validate_presence_of :loan_id }
        it { is_expected.to validate_presence_of :employee_id }
        it { is_expected.to validate_presence_of :principal_amount }
        it { is_expected.to validate_presence_of :interest_amount }
        it { is_expected.to validate_presence_of :penalty_amount }
        it { is_expected.to validate_numericality_of(:principal_amount).is_greater_than_or_equal_to(0) }
        it { is_expected.to validate_numericality_of(:interest_amount).is_greater_than_or_equal_to(0) }
        it { is_expected.to validate_numericality_of(:penalty_amount).is_greater_than_or_equal_to(0) }
      end 

      it "#process" do 
        bookkeeper = create(:bookkeeper)
        loan       = create(:loan, office: bookkeeper.office)
        cart       = create(:cart, employee: bookkeeper)

        described_class.new(
        loan_id:          loan.id, 
        cart_id:          cart.id, 
        employee_id:      bookkeeper.id,
        principal_amount: 100,
        interest_amount:  200,
        penalty_amount:   300).process!

        expect(cart.voucher_amounts.pluck(:account_id)).to include(loan.receivable_account_id)
        expect(cart.voucher_amounts.pluck(:account_id)).to include(loan.interest_revenue_account_id)
        expect(cart.voucher_amounts.pluck(:account_id)).to include(loan.penalty_revenue_account_id)
        expect(cart.voucher_amounts.where(account_id: loan.receivable_account_id).total).to eql 100 
        expect(cart.voucher_amounts.where(account_id: loan.interest_revenue_account_id).total).to eql 200 
        expect(cart.voucher_amounts.where(account_id: loan.penalty_revenue_account_id).total).to eql 300 

      end 
    end 
  end 
end 