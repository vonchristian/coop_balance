require 'rails_helper'

module AccountingModule
  module IocDistributions
    describe IocToSaving, type: :model do 
      describe "attributes" do 
        it { is_expected.to respond_to(:cart_id) }
        it { is_expected.to respond_to(:saving_id) }
        it { is_expected.to respond_to(:employee_id) }
        it { is_expected.to respond_to(:amount) }
      end 
      
      describe "validations" do 
        it { is_expected.to validate_presence_of :cart_id }
        it { is_expected.to validate_presence_of :saving_id }
        it { is_expected.to validate_presence_of :employee_id }
        it { is_expected.to validate_presence_of :amount }
        it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
      end 

      it "#process!" do 
        bookkeeper = create(:bookkeeper)
        saving     = create(:saving, office: bookkeeper.office)
        cart       = create(:cart, employee: bookkeeper)

        described_class.new(
          employee_id: bookkeeper.id, 
          saving_id:   saving.id,
          cart_id:     cart.id, 
          amount:      100
        ).process!

        expect(cart.voucher_amounts.pluck(:account_id)).to include(saving.liability_account_id)
        expect(cart.voucher_amounts.where(account_id: saving.liability_account_id).total).to eql 100

      end 
    end 
  end 
end 