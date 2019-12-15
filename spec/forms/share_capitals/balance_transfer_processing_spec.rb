require 'rails_helper'

module ShareCapitals
  describe BalanceTransferProcessing, type: :model do
    describe 'attributes' do
      it { is_expected.to respond_to(:origin_share_capital_id) }
      it { is_expected.to respond_to(:destination_share_capital_id) }
      it { is_expected.to respond_to(:employee_id) }
      it { is_expected.to respond_to(:cart_id) }
      it { is_expected.to respond_to(:amount) }
    end

    describe 'validations' do
      it { is_expected.to validate_presence_of :amount }
      it { is_expected.to validate_numericality_of :amount }
      it { is_expected.to validate_presence_of :origin_share_capital_id }
      it { is_expected.to validate_presence_of :destination_share_capital_id }
      it { is_expected.to validate_presence_of :cart_id }
      it { is_expected.to validate_presence_of :employee_id }
    end

    it "#process!" do
      bookkeeper      = create(:bookkeeper)
      office          = bookkeeper.office
      share_capital_1 = create(:share_capital, office: office)
      share_capital_2 = create(:share_capital, office: office)
      cart            = create(:cart, employee: bookkeeper)

      described_class.new(
        employee_id:                  bookkeeper.id,
        origin_share_capital_id:      share_capital_1.id,
        destination_share_capital_id: share_capital_2.id,
        amount:                       100,
        cart_id:                      cart.id
      ).process!

      expect(cart.voucher_amounts.pluck(:account_id)).to include(share_capital_1.equity_account_id)
      expect(cart.voucher_amounts.pluck(:account_id)).to include(share_capital_2.equity_account_id)
    end
  end
end
