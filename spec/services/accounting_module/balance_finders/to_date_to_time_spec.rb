require 'rails_helper'

module AccountingModule
  module BalanceFinders
    describe ToDateToTime do
      it '.compute' do
        asset       = create(:asset)
        revenue     = create(:revenue)
        entry       = build(:entry, entry_date: Date.current, entry_time: 2.hours.ago)
        entry.debit_amounts.build(amount: 100, account: asset)
        entry.credit_amounts.build(amount: 100, account: revenue)
        entry.save!

        entry_2 = build(:entry, entry_date: Date.current, entry_time: 2.hours.from_now)
        entry_2.debit_amounts.build(amount: 300, account: asset)
        entry_2.credit_amounts.build(amount: 300, account: revenue)
        entry_2.save!

        expect(described_class.new(amounts: AccountingModule::Amount.all, to_date: Date.current, to_time: 3.hours.ago).compute).to be 0
        expect(described_class.new(amounts: AccountingModule::Amount.all, to_date: Date.current, to_time: 1.hour.from_now).compute).to be 200
        expect(described_class.new(amounts: AccountingModule::Amount.all, to_date: Date.current, to_time: 2.hours.from_now).compute).to be 800
      end
    end
  end
end
