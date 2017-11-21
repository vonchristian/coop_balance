class RemoveTimeDepositProductFromBreakContractFees < ActiveRecord::Migration[5.1]
  def change
    remove_reference :break_contract_fees, :time_deposit_product, foreign_key: true
  end
end
