class AddCooperativeToServinces < ActiveRecord::Migration[5.2]
  def change
    add_reference :interest_configs, :cooperative, foreign_key: true, type: :uuid
    add_reference :penalty_configs, :cooperative, foreign_key: true, type: :uuid
    add_reference :saving_products, :cooperative, foreign_key: true, type: :uuid
    add_reference :time_deposit_products, :cooperative, foreign_key: true, type: :uuid
    add_reference :share_capital_products, :cooperative, foreign_key: true, type: :uuid
  end
end
