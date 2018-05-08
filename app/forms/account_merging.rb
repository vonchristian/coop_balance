class AccountMerging
  include ActiveModel::Model
  attr_accessor :merger_id, :mergee_id

  def merge!
    ActiveRecord::Base.transaction do
      merge_account
    end
  end

  private
  def merge_account
    find_merger.savings        << find_mergee.savings
    find_merger.time_deposits  << find_mergee.time_deposits
    find_merger.share_capitals << find_mergee.share_capitals
    find_merger.loans          << find_mergee.loans
  end

  def find_merger
    Member.find_by_id(merger_id)
  end

  def find_mergee
    Member.find_by_id(mergee_id)
  end
end
