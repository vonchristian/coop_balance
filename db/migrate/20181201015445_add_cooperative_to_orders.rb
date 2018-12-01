class AddCooperativeToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :cooperative, foreign_key: true, type: :uuid
  end
end
