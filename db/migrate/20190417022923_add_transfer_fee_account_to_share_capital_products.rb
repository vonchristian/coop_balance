class AddTransferFeeAccountToShareCapitalProducts < ActiveRecord::Migration[5.2]
  def change
  	add_reference :share_capital_products, :transfer_fee_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end