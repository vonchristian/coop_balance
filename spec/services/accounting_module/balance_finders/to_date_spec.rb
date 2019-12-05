require 'rails_helper'

module AccountingModule
  module BalanceFinders
    describe ToDate do
      it '.compute' do
        cooperative = create(:cooperative)
        asset       = create(:asset)
        revenue     = create(:revenue)
        cooperative.accounts << asset
        cooperative.accounts << revenue
        entry        = build(:entry, cooperative: cooperative,  entry_date: Date.current)
        entry.debit_amounts.build(amount: 100, account: asset)
        entry.credit_amounts.build(amount: 100, account: revenue)
        entry.save!

        entry_2 = build(:entry,cooperative: cooperative, entry_date: Date.current.last_year)
        entry_2.debit_amounts.build(amount: 300, account: asset)
        entry_2.credit_amounts.build(amount: 300, account: revenue)
        entry_2.save!

        expect(described_class.new(amounts: AccountingModule::Amount.all, to_date: Date.current).compute).to eql 800

        expect(described_class.new(amounts: AccountingModule::Amount.all, to_date: Date.current.last_year).compute).to eql 600

      end
    end
  end
end
