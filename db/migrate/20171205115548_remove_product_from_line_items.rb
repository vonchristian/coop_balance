class RemoveProductFromLineItems < ActiveRecord::Migration[5.2]
  def change
    remove_reference :line_items, :product, foreign_key: true, type: :uuid
    remove_reference :line_items, :product_stock, foreign_key: true, type: :uuid
  end
end
