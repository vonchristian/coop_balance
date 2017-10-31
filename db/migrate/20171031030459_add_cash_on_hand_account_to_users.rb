class AddCashOnHandAccountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :cash_on_hand_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
