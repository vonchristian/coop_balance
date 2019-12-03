require 'rails_helper'

module AccountCreators
  describe ShareCapitalApplication do
    it '#create_accounts!' do
      share_capital_application = build(:share_capital_application, equity_account_id: nil)

      described_class.new(share_capital_application: share_capital_application).create_accounts!

      expect(share_capital_application.equity_account).to_not eq nil
    end
  end
end 
