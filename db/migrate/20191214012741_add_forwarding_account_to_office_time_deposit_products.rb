class AddForwardingAccountToOfficeTimeDepositProducts < ActiveRecord::Migration[6.0]
  def change
    add_reference :office_time_deposit_products, :forwarding_account, null: false, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
