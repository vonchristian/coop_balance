module AccountCreators
  class ProgramSubscription
    attr_reader :program_subscription, :program, :level_one_account_category

    def initialize(program_subscription:)
      @program_subscription       = program_subscription
      @program                    = @program_subscription.program
      @office_program             = Offices::OfficeProgram.where(office: @program_subscription.office, program: @program).last
      @level_one_account_category = @office_program.level_one_account_category
    end

    def create_accounts!
      if program_subscription.account.blank?
        account = account_category.accounts.create!(
        type:             "AccountingModule::Accounts::#{level_one_account_category.normalized_type}",
        name:             "#{program.name} (#{program_subscription.subscriber_name} - #{program_subscription.account_number}",
        code:             program_subscription.account_number)
        program_subscription.update!(account: account)
      end
    end
  end
end
