class AddBalanceAveragingTypeToShareCapitalProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :share_capital_products, :balance_averaging_type, :integer, index: true
  end
end
