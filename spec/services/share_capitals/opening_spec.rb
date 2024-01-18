require 'rails_helper'

module ShareCapitals
  describe Opening do
    it '#process!' do
      share_capital_application = create(:share_capital_application)
      voucher = create(:voucher)
      teller = create(:teller)

      described_class.new(voucher: voucher, share_capital_application: share_capital_application, employee: teller).process!
      share_capital = teller.office.share_capitals.find_by(account_number: share_capital_application.account_number)

      expect(share_capital).not_to eql nil
      expect(share_capital.equity_account_id).not_to eql nil
      expect(share_capital.interest_on_capital_account_id).not_to eql nil
    end
  end
end
