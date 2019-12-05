module Migrators
  class ProgramSubscription
    attr_reader :program_subscription, :program, :account

    def initialize(program_subscription:)
      @program_subscription = program_subscription
      @program              = @program_subscription.program
      @account              = @program.account
    end

    def migrate_entries!
      migrate_account_entries
    end

    private

    def migrate_account_entries
      account.credit_amounts.where(commercial_document: program_subscription).each do |amount|
        amount.update!(account: program_subscription.program_account)
      end
    end
  end
end
