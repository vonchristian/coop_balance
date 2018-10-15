class RemoveCashOnHandAccountFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_reference :users, :cash_on_hand_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
