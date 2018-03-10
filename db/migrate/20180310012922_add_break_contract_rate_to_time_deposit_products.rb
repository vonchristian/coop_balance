class AddBreakContractRateToTimeDepositProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :time_deposit_products, :break_contract_rate, :decimal
  end
end
