require 'rails_helper'

module SavingsAccounts
  describe MultiplePaymentVoucherProcessing, type: :model do 
    describe 'validations' do 
      it { is_expected.to validate_presence_of :cart_id }
      it { is_expected.to validate_presence_of :date }
      it { is_expected.to validate_presence_of :reference_number }
      it { is_expected.to validate_presence_of :description }
      it { is_expected.to validate_presence_of :cash_account_id }
      it { is_expected.to validate_presence_of :account_number }
    end 

    it "process!" do 
      teller         = create(:teller)
      cash           = create(:asset)
      cart           = create(:cart, employee: teller)
      credit_amount  = create(:voucher_amount, amount_type: 'credit', amount: 1000, cart: cart)
      account_number = 'test-account-number'
      
      described_class.new(
        date:             Date.current,
        cash_account_id:  cash.id,
        cart_id:          cart.id, 
        employee_id:      teller.id,
        reference_number: 'test',
        description:      'test description',
        account_number:   account_number
      ).process!



      voucher = teller.office.vouchers.find_by!(account_number: account_number)

      expect(voucher).to_not eq nil 
      expect(voucher.voucher_amounts.pluck(:id)).to include(credit_amount.id)
     
    end 
  end 
end 
