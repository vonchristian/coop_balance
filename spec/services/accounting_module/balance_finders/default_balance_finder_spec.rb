require 'rails_helper'

module AccountingModule
  module BalanceFinders
    describe DefaultBalanceFinder do
      it '.compute' do
        cooperative = create(:cooperative)
        asset       = create(:asset)
        revenue     = create(:revenue)
        cooperative.accounts << asset
        cooperative.accounts << revenue
        entry = build(:entry, cooperative: cooperative)
        entry.debit_amounts.build(amount: 100, account: asset)
        entry.credit_amounts.build(amount: 100, account: revenue)
        entry.save!

        cooperative = create(:cooperative)
        asset       = create(:asset)
        revenue     = create(:revenue)
        cooperative.accounts << asset
        cooperative.accounts << revenue
        entry = build(:entry, cooperative: cooperative, cancelled: true)
        entry.debit_amounts.build(amount: 100, account: asset)
        entry.credit_amounts.build(amount: 100, account: revenue)
        entry.save!

        expect(described_class.new(amounts: AccountingModule::Amount.all).compute).to be 200
      end
    end
  end
end
