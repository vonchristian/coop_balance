class RemovePenaltyDiscountAccountFromPenaltyConfigs < ActiveRecord::Migration[5.2]
  def change
    remove_reference :penalty_configs, :penalty_discount_account, foreign_key: { to_table: :accounts }, type: :uuid
    remove_reference :penalty_configs, :penalty_receivable_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
