require 'rails_helper'

module AccountingModule
  module BalanceFinders
    describe CooperativeServiceToDate do
      it '.compute' do
        cooperative = create(:cooperative)
        cooperative_service = create(:cooperative_service, cooperative: cooperative)
        asset = create(:asset)
        revenue = create(:revenue)
        cooperative.accounts << asset
        cooperative.accounts << revenue
      
        entry = build(:entry, cooperative: cooperative, cooperative_service: cooperative_service, entry_date: Date.current.last_month)
        entry.debit_amounts.build(amount: 100, account: asset)
        entry.credit_amounts.build(amount: 100, account: revenue)
        entry.save!

        entry_2 = build(:entry, cooperative: cooperative, cooperative_service: cooperative_service, entry_date: Date.current)
        entry_2.debit_amounts.build(amount: 300, account: asset)
        entry_2.credit_amounts.build(amount: 300, account: revenue)
        entry_2.save!


        expect(described_class.new(amounts: AccountingModule::Amount.all, cooperative_service: cooperative_service, to_date: Date.current.last_month).compute).to eql 200
        expect(described_class.new(amounts: AccountingModule::Amount.all, cooperative_service: cooperative_service, to_date: Date.current).compute).to eql 800
      end
    end
  end
end
