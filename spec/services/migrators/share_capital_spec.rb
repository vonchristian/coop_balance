require 'rails_helper'

module Migrators
  describe ShareCapital do
    it '#migrate_entries' do
      asset         = create(:asset)
      teller        = create(:teller)
      share_capital = create(:share_capital)
      entry         = build(:entry, recorder: teller, office: teller.office, cooperative: teller.cooperative, commercial_document: share_capital)
      entry.debit_amounts.build(account: asset, amount: 100, commercial_document: share_capital, commercial_document: share_capital)
      entry.credit_amounts.build(account: share_capital.share_capital_product_equity_account, amount: 100, commercial_document: share_capital)
      entry.save!

      expect(share_capital.balance).to eql 100
      expect(share_capital.share_capital_equity_account.balance).to eql 0

      described_class.new(share_capital: share_capital).migrate_entries!

      expect(share_capital.share_capital_equity_account.balance).to eql 100

    end
  end
end
