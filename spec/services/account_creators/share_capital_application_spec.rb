require 'rails_helper'

module AccountCreators
  describe ShareCapitalApplication do
    it '#create_accounts!' do
      office = create(:office)
      share_capital_product = create(:share_capital_product)
      create(:office_share_capital_product, office: office, share_capital_product: share_capital_product)
      share_capital_application = build(:share_capital_application, office: office, share_capital_product: share_capital_product, equity_account_id: nil)

      described_class.new(share_capital_application: share_capital_application).create_accounts!

      expect(share_capital_application.equity_account).to_not eq nil
    end
  end
end 
