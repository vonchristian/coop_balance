class AddAccountToTimeDepositProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :time_deposit_products, :account, foreign_key: true, type: :uuid
  end
end
