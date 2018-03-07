class AddPenaltyDiscountToPenaltyConfigs < ActiveRecord::Migration[5.1]
  def change
    add_reference :penalty_configs, :penalty_discount_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
