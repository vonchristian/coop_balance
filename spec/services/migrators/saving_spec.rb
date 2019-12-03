require 'rails_helper'

module Migrators
  describe Saving do
    describe '#migrate_entries' do
      it '#migrate_liability_account_entries' do
        asset         = create(:asset)
        teller        = create(:teller)
        saving        = create(:saving)
        entry         = build(:entry, recorder: teller, office: teller.office, cooperative: teller.cooperative, commercial_document: saving)
        entry.debit_amounts.build(account: asset, amount: 100, commercial_document: saving)
        entry.credit_amounts.build(account: saving.saving_product_account, amount: 100, commercial_document: saving)
        entry.save!

        expect(saving.balance).to eql 100
        expect(saving.liability_account.balance).to eql 0

        described_class.new(saving: saving).migrate_entries!

        expect(saving.liability_account.balance).to eql 100

      end

      it '#migrate_interest_expense_account_entries' do
        asset         = create(:asset)
        teller        = create(:teller)
        saving        = create(:saving)
        entry         = build(:entry, recorder: teller, office: teller.office, cooperative: teller.cooperative, commercial_document: saving)
        entry.debit_amounts.build(account: saving.saving_product_interest_expense_account, amount: 100, commercial_document: saving)
        entry.credit_amounts.build(account: saving.saving_product_account, amount: 100, commercial_document: saving)
        entry.save!

        expect(saving.interest_expense_account.balance).to eql 0

        described_class.new(saving: saving).migrate_entries!

        expect(saving.interest_expense_account.balance).to eql 100

      end

    end
  end
end
