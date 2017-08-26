class AddAmortizeBalanceToChargeAdjustments < ActiveRecord::Migration[5.1]
  def change
    add_column :charge_adjustments, :amortize_balance, :boolean, default: false
  end
end
