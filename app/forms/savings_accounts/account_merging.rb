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
      find_mergee.depositor = find_merger.depositor
      AccountingModule::Amount.where(commercial_document: find_mergee).each do |amount|
        amount.commercial_document = find_merger
        amount.save
      end
      find_mergee.save
    end
    def find_merger
      MembershipsModule::Saving.find_by_id(merger_id)
    end
    def find_mergee
      MembershipsModule::Saving.find_by_id(mergee_id)
    end
  end
end
