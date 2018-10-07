class RemoveLogoFromCooperative < ActiveRecord::Migration[5.2]
  def up
    remove_attachment :cooperatives, :logo
    remove_attachment :users, :avatar

  end
  def down
    add_attachment :bank_accounts, :avatar
    add_attachment :users, :avatar
  end
end
