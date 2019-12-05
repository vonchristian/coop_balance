require 'rails_helper'

module AccountingModule
  module BalanceFinders
    describe Office do
      it '.compute' do
        cooperative = create(:cooperative)
        office_1      = create(:main_office, cooperative: cooperative)
        office_2    = create(:main_office, cooperative: cooperative)
        asset       = create(:asset)
        revenue     = create(:revenue)
        cooperative.accounts << asset
        cooperative.accounts << revenue
        origin_entry = create(:origin_entry, cooperative: cooperative)
        entry        = build(:entry, cooperative: cooperative, office: office_1, entry_date: Date.current)
        entry.debit_amounts.build(amount: 100, account: asset)
        entry.credit_amounts.build(amount: 100, account: revenue)
        entry.save!

        entry_2 = build(:entry, cooperative: cooperative, office: office_2, entry_date: Date.current.last_year)
        entry_2.debit_amounts.build(amount: 300, account: asset)
        entry_2.credit_amounts.build(amount: 300, account: revenue)
        entry_2.save!

        expect(described_class.new(amounts: AccountingModule::Amount.all, office: office_1).compute).to eql 200

        expect(described_class.new(amounts: AccountingModule::Amount.all, office: office_2).compute).to eql 600

      end
    end
  end
end
