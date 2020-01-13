require 'rails_helper'

module ShareCapitals
  describe MultiplePayment, type: :model do 
    describe 'validations' do 
      it { is_expected.to validate_presence_of :amount }
      it { is_expected.to validate_presence_of :share_capital_id }
      it { is_expected.to validate_presence_of :cart_id }
      it { is_expected.to validate_presence_of :employee_id }
      it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
    end 

    it '#process!' do 
      teller        = create(:teller)
      cart          = create(:cart, employee: teller)
      share_capital = create(:share_capital, office: teller.office)

      described_class.new(
        cart_id:          cart.id, 
        amount:           1_000,
        employee_id:      teller.id,
        share_capital_id: share_capital.id
      ).process!

      expect(cart.voucher_amounts.credit.total).to eql 1_000
      expect(cart.voucher_amounts.pluck(:account_id)).to include(share_capital.equity_account_id)
    end 
  end 
end 