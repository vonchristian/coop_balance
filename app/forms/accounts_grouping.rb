class AccountsGrouping
  include ActiveModel::Model
  attr_accessor :sub_account_ids, :main_account_id, :cooperative_id

  def group!
    return if find_accounts.blank?

    ActiveRecord::Base.transaction do
      find_accounts.each do |account|
        account.update(main_account: find_main_account)
      end
    end
  end

  def find_main_account
    find_cooperative.accounts.find(main_account_id)
  end

  def find_accounts
    find_cooperative.accounts.where(id: sub_account_ids.compact)
  end

  def find_cooperative
    Cooperative.find(cooperative_id)
  end
end
