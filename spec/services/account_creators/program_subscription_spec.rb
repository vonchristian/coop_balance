require 'rails_helper'

module AccountCreators
  describe ProgramSubscription do
    it "#create_accounts!" do
      program_subscription = build(:program_subscription, account_id: nil)

      described_class.new(program_subscription: program_subscription).create_accounts!
      program_subscription.save!

      expect(program_subscription.account).to_not eql nil 
    end
  end
end
