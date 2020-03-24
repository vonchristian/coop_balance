require 'rails_helper'

module AccountingModule
  module IocDistributions
    describe IocVoucher, type: :model do 
      describe "attributes" do 
        it { is_expected.to respond_to(:date) }
        it { is_expected.to respond_to(:reference_number) }
        it { is_expected.to respond_to(:description) }
        it { is_expected.to respond_to(:cart_id) }
        it { is_expected.to respond_to(:employee_id) }
        it { is_expected.to respond_to(:account_number) }
      end 

      describe "validations" do 
        it { is_expected.to validate_presence_of :date }
        it { is_expected.to validate_presence_of :reference_number }
        it { is_expected.to validate_presence_of :description }
        it { is_expected.to validate_presence_of :cart_id }
        it { is_expected.to validate_presence_of :employee_id }
        it { is_expected.to validate_presence_of :account_number }
      end 

      it "process!" do 
        bookkeeper            = create(:bookkeeper)
        cart                  = create(:cart, employee: bookkeeper)
        net_income_config     = create(:net_income_config, office: bookkeeper.office)
        credit_voucher_amount = create(:voucher_amount, amount_type: 'credit', amount: 100, cart: cart)

        described_class.new(
          employee_id:      bookkeeper.id, 
          cart_id:          cart.id, 
          reference_number: "test ref",
          description:      "test description",
          account_number:   "test account number",
          date:             Date.current).
          process!
        
        voucher = bookkeeper.office.vouchers.find_by(account_number: "test account number")
        
        expect(voucher).to_not eq nil 
        expect(voucher.voucher_amounts.pluck(:id)).to include(credit_voucher_amount.id)
        expect(voucher.voucher_amounts.pluck(:account_id)).to include(credit_voucher_amount.account_id)
        expect(voucher.voucher_amounts.pluck(:account_id)).to include(net_income_config.interest_on_capital_account_id)
        expect(voucher.voucher_amounts.credit.total).to eql 100 
        expect(voucher.voucher_amounts.debit.total).to  eql 100 
      end 
    end 
  end 
end 
