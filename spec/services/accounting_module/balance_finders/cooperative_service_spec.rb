require 'rails_helper'

module AccountingModule
  module BalanceFinders
    describe CooperativeService do
      it '.compute' do
        cooperative = create(:cooperative)
        cooperative_service = create(:cooperative_service, cooperative: cooperative)
        asset = create(:asset)
        revenue = create(:revenue)
        cooperative.accounts << asset
        cooperative.accounts << revenue
        origin_entry = create(:origin_entry, cooperative: cooperative)
        entry = build(:entry, previous_entry: origin_entry, cooperative: cooperative, cooperative_service: cooperative_service)
        entry.debit_amounts.build(amount: 200, account: asset)
        entry.credit_amounts.build(amount: 200, account: revenue)
        entry.save!

        expect(described_class.new(amounts: AccountingModule::Amount.all, cooperative_service: cooperative_service).compute).to eql 400
      end
    end
  end
end
