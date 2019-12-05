require 'rails_helper'

module AccountCreators
  describe ProgramSubscription do
    it "#create_accounts!" do
      office               = create(:office)
      program              = create(:program)
      program_subscription = build(:program_subscription, program: program, office: office, account_id: nil)
      create(:office_program, office: office, program: program)

      described_class.new(program_subscription: program_subscription).create_accounts!
      program_subscription.save!

      expect(program_subscription.program_account).to_not eql nil
    end
  end
end
