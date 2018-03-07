class AddAvatarToBankAccounts < ActiveRecord::Migration[5.1]
  def up
    add_attachment :bank_accounts, :avatar
  end
  def down
    remove_attachment :bank_accounts, :avatar
  end
end
