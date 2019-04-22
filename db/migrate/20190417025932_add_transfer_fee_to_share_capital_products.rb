class AddTransferFeeToShareCapitalProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :share_capital_products, :transfer_fee, :decimal
  end
end
