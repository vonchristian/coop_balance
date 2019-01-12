require 'rails_helper'

module AccountingModule
  module BalanceFinders
    describe Amounts do
      it '.compute' do
        cooperative = create(:cooperative)
        asset = create(:asset)
        revenue = create(:revenue)
        cooperative.accounts << asset
        cooperative.accounts << revenue
        origin_entry = create(:origin_entry, cooperative: cooperative)
        entry = build(:entry, previous_entry: origin_entry, cooperative: cooperative)
        entry.debit_amounts.build(amount: 100, account: asset)
        entry.credit_amounts.build(amount: 100, account: revenue)
        entry.save!

        expect(described_class.new(amounts: AccountingModule::Amount.all).compute).to eql 200
      end
    end
  end
end
