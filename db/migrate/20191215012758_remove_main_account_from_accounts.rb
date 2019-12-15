class RemoveMainAccountFromAccounts < ActiveRecord::Migration[6.0]
  def change
    remove_reference :accounts, :main_account, foreign_key: { to_table: :accounts }, type: :uuid 
  end
end
