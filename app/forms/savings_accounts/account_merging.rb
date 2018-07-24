module SavingsAccounts
  class AccountMerging
    include ActiveModel::Model
    attr_accessor :merger_id, :mergee_id

    def merge!
      ActiveRecord::Base.transaction do
        merge_accounts
      end
    end

    private
    def merge_accounts
      find_merger.debit_amounts << find_mergee.debit_amounts
      find_merger.credit_amounts << find_mergee.credit_amounts
    end
    def find_merger
      MembershipsModule::Saving.find_by_id(merger_id)
    end
    def find_mergee
      MembershipsModule::Saving.find_by_id(mergee_id)
    end
  end
end
