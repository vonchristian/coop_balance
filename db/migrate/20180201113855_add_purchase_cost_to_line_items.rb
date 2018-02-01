class AddPurchaseCostToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items, :purchase_cost, :decimal
    add_column :line_items, :selling_cost, :decimal
  end
end
