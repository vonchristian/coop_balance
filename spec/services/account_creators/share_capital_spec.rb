require 'rails_helper'

module AccountCreators
  describe ShareCapital, type: :model do
    it 'create_accounts!' do
      cooperative                  = create(:cooperative)
      office                       = create(:office, cooperative: cooperative)
      equity_ledger                = create(:equity_ledger)
      share_capital_product        = create(:share_capital_product, name: 'Share Capital - Common', cooperative: cooperative)
      create(:office_share_capital_product, office: office, share_capital_product: share_capital_product, equity_ledger: equity_ledger)
      share_capital = build(:share_capital, office: office, equity_account_id: nil, share_capital_product: share_capital_product)

      described_class.new(share_capital: share_capital).create_accounts!
      share_capital.save!

      equity_account = share_capital.share_capital_equity_account
      expect(share_capital.share_capital_equity_account).to eql equity_account
      expect(share_capital.accounts).to include(equity_account)
      expect(equity_ledger.accounts).to include(equity_account)
    end
  end
end
