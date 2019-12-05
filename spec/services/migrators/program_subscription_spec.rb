require 'rails_helper'

module Migrators
  describe ProgramSubscription, type: :model do
    it "#migrate_entries!" do
      teller  = create(:teller)
      cash    = create(:asset)
      program = create(:program)
      program_subscription = create(:program_subscription, program: program)
      entry = build(:entry, recorder: teller, office: teller.office, cooperative: teller.cooperative)
      entry.debit_amounts.build(account: cash, commercial_document: program_subscription)
      entry.credit_amounts.build(account: program.account, commercial_document: program_subscription)
      entry.save!

      expect(program_subscription.account.balance).to eql 0

      described_class.new(program_subscription: program_subscription).migrate_entries!

      expect(program_subscription.account.amounts).to_not eql 0
    end
  end
end
