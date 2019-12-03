require 'rails_helper'

module AccountCreators
  describe ShareCapital do
    it '#create_accounts' do
      share_capital = build(:share_capital, equity_account_id: nil, interest_on_capital_account_id: nil)

      described_class.new(share_capital: share_capital).create_accounts!

      share_capital.save!

      expect(share_capital.share_capital_equity_account).to_not be nil?
      expect(share_capital.interest_on_capital_account).to_not be nil?
    end
  end
end
