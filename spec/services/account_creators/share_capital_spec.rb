require 'rails_helper'

module AccountCreators
  describe ShareCapital, type: :model do
    it 'create_accounts!' do
      cooperative                  = create(:cooperative)
      office                       = create(:office, cooperative: cooperative)
      share_capital_product        = create(:share_capital_product, name: 'Share Capital - Common', cooperative: cooperative)
      office_share_capital_product = create(:office_share_capital_product, office: office, share_capital_product: share_capital_product)
      share_capital                = build(:share_capital, office: office, share_capital_equity_account: nil,  share_capital_product: share_capital_product)
      described_class.new(share_capital: share_capital).create_accounts!
      share_capital.save!

      equity_account = AccountingModule::Equity.find_by!(name: "#{share_capital_product.name} - (#{share_capital.subscriber_name} - #{share_capital.account_number}")

      expect(share_capital.share_capital_equity_account).to              eql equity_account

      expect(office_share_capital_product.equity_account_category.accounts).to include(share_capital.share_capital_equity_account)

    end
  end
end
