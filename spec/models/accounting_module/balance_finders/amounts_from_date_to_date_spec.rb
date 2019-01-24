require 'rails_helper'

module AccountingModule
  module BalanceFinders
    describe AmountsFromDateToDate do
      it '.compute' do
        cooperative = create(:cooperative)
        asset       = create(:asset)
        revenue     = create(:revenue)
        cooperative.accounts << asset
        cooperative.accounts << revenue
        origin_entry = create(:origin_entry, cooperative: cooperative)
        entry        = build(:entry, previous_entry: origin_entry, cooperative: cooperative,  entry_date: Date.current)
        entry.debit_amounts.build(amount: 100, account: asset)
        entry.credit_amounts.build(amount: 100, account: revenue)
        entry.save!

        entry_2 = build(:entry, previous_entry: entry, cooperative: cooperative, entry_date: Date.yesterday)
        entry_2.debit_amounts.build(amount: 300, account: asset)
        entry_2.credit_amounts.build(amount: 300, account: revenue)
        entry_2.save!

        expect(described_class.new(amounts: AccountingModule::Amount.all, from_date: Date.current, to_date: Date.current).compute).to eql 200

        expect(described_class.new(amounts: AccountingModule::Amount.all, from_date: Date.yesterday, to_date: Date.yesterday).compute).to eql 600

      end
    end
  end
end