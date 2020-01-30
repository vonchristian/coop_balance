require 'rails_helper'

module AccountingModule
  module BalanceFinders
    describe ToDateToTime do
      it '.compute' do
        cooperative = create(:cooperative)
        asset       = create(:asset)
        revenue     = create(:revenue)
        cooperative.accounts << asset
        cooperative.accounts << revenue
        entry        = build(:entry, cooperative: cooperative,  entry_date: Date.current, created_at: Time.zone.now - 1.hour)
        entry.debit_amounts.build(amount: 100, account: asset)
        entry.credit_amounts.build(amount: 100, account: revenue)
        entry.save!

        entry_2 = build(:entry,cooperative: cooperative, entry_date: Date.current, created_at: Time.zone.now + 1.hour)
        entry_2.debit_amounts.build(amount: 300, account: asset)
        entry_2.credit_amounts.build(amount: 300, account: revenue)
        entry_2.save!

        expect(described_class.new(amounts: AccountingModule::Amount.all, to_date: Date.current, to_time: Time.zone.now - 3.hour).compute).to eql 0
        expect(described_class.new(amounts: AccountingModule::Amount.all, to_date: Date.current, to_time: Time.zone.now).compute).to eql 200
        expect(described_class.new(amounts: AccountingModule::Amount.all, to_date: Date.current, to_time: Time.zone.now + 1.hour).compute).to eql 800

      end
    end
  end
end
