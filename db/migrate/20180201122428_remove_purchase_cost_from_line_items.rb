class RemovePurchaseCostFromLineItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :line_items, :purchase_cost, :decimal
    remove_column :line_items, :selling_cost, :decimal
  end
end
