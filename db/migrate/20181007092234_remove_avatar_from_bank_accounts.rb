class RemoveAvatarFromBankAccounts < ActiveRecord::Migration[5.2]
  def up
    remove_attachment :bank_accounts, :avatar
  end
  def down
    add_attachment :bank_accounts, :avatar
  end
end
