require 'rails_helper'

module AccountingModule
  module BalanceFinders
    describe AmountsCommercialDocumentFromDateToDate do
      it '.compute' do
        cooperative = create(:cooperative)
        liability   = create(:liability)
        asset   = create(:asset)
        saving_product = create(:saving_product, cooperative: cooperative, account: liability)

        cooperative.accounts << liability
        cooperative.accounts << asset

        saving = create(:saving, cooperative: cooperative, saving_product: saving_product)

        origin_entry = create(:origin_entry, cooperative: cooperative)
        entry = build(:entry, previous_entry: origin_entry, cooperative: cooperative, entry_date: Date.current.last_month)
        entry.debit_amounts.build(amount: 100, account: asset,    commercial_document: saving)
        entry.credit_amounts.build(amount: 100, account: liability, commercial_document: saving)
        entry.save!

        entry_2 = build(:entry, previous_entry: origin_entry, cooperative: cooperative, entry_date: Date.current)
        entry_2.debit_amounts.build(amount: 300, account: asset,    commercial_document: saving)
        entry_2.credit_amounts.build(amount: 300, account: liability, commercial_document: saving)
        entry_2.save!

        expect(described_class.new(amounts: AccountingModule::Amount.all, commercial_document: saving, from_date: Date.current.last_month.beginning_of_month, to_date: Date.current.last_month.end_of_month).compute).to eql 200
        expect(described_class.new(amounts: AccountingModule::Amount.all, commercial_document: saving, from_date: Date.current.beginning_of_month, to_date: Date.current.end_of_month).compute).to eql 600
        expect(described_class.new(amounts: AccountingModule::Amount.all, commercial_document: saving, from_date: Date.current.last_month.beginning_of_month, to_date: Date.current.end_of_month).compute).to eql 800
      end
    end
  end
end
