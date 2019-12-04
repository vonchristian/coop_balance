require 'rails_helper'

module Migrators
  describe TimeDeposit do
    describe '#migrate_entries' do
      it '#migrate_liability_account_entries' do
        asset         = create(:asset)
        teller        = create(:teller)
        time_deposit  = create(:time_deposit)
        entry         = build(:entry, recorder: teller, office: teller.office, cooperative: teller.cooperative, commercial_document: time_deposit)
        entry.debit_amounts.build(account: asset, amount: 100, commercial_document: time_deposit)
        entry.credit_amounts.build(account: time_deposit.time_deposit_product_account, amount: 100, commercial_document: time_deposit)
        entry.save!

        expect(time_deposit.liability_account.balance).to eql 0

        described_class.new(time_deposit: time_deposit).migrate_entries!

        expect(time_deposit.liability_account.balance).to eql 100

      end

      it '#migrate_interest_expense_account_entries' do
        asset         = create(:asset)
        teller        = create(:teller)
        time_deposit  = create(:time_deposit)
        entry         = build(:entry, recorder: teller, office: teller.office, cooperative: teller.cooperative, commercial_document: time_deposit)
        entry.debit_amounts.build(account: time_deposit.time_deposit_product_interest_expense_account, amount: 100, commercial_document: time_deposit)
        entry.credit_amounts.build(account: time_deposit.time_deposit_product_account, amount: 100, commercial_document: time_deposit)
        entry.save!

        expect(time_deposit.interest_expense_account.balance).to eql 0

        described_class.new(time_deposit: time_deposit).migrate_entries!

        expect(time_deposit.interest_expense_account.balance).to eql 100

      end

      it '#migrate_break_contract_entries' do
        asset         = create(:asset)
        teller        = create(:teller)
        time_deposit  = create(:time_deposit)
        entry         = build(:entry, recorder: teller, office: teller.office, cooperative: teller.cooperative, commercial_document: time_deposit)
        entry.debit_amounts.build(account: time_deposit.time_deposit_break_contract_account, amount: 100, commercial_document: time_deposit)
        entry.credit_amounts.build(account: asset, amount: 100, commercial_document: time_deposit)
        entry.save!

        expect(time_deposit.break_contract_account.balance).to eql 0

        described_class.new(time_deposit: time_deposit).migrate_entries!

        expect(time_deposit.break_contract_account.balance).to eql 100

      end

    end
  end
end
