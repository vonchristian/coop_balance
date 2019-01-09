require 'rails_helper'

module AccountingModule
  module BalanceFinders
    describe AmountsCommercialDocument do
      it '.compute' do
        cooperative = create(:cooperative)
        liability   = create(:liability)
        asset   = create(:asset)
        saving_product = create(:saving_product, cooperative: cooperative, account: liability)

        cooperative.accounts << liability
        cooperative.accounts << asset

        saving = create(:saving, cooperative: cooperative, saving_product: saving_product)

        origin_entry = create(:origin_entry, cooperative: cooperative)
        entry = build(:entry, previous_entry: origin_entry, cooperative: cooperative)
        entry.debit_amounts.build(amount: 100, account: asset,    commercial_document: saving)
        entry.credit_amounts.build(amount: 100, account: liability, commercial_document: saving)
        entry.save!

        expect(described_class.new(amounts: AccountingModule::Amount.all, commercial_document: saving).compute).to eql 200
      end
    end
  end
end
