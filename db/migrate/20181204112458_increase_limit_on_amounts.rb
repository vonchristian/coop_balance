class IncreaseLimitOnAmounts < ActiveRecord::Migration[5.2]
  def change
    change_column :amounts, :amount_cents, :integer, limit: 8, default: 0, null: false
  end
end
