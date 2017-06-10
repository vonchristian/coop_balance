class AddHasFreightToRawMaterialStocks < ActiveRecord::Migration[5.1]
  def change
    add_column :raw_material_stocks, :has_freight, :boolean, default: false
    add_column :raw_material_stocks, :discounted, :boolean, default: false
    add_column :raw_material_stocks, :freight_in, :decimal, default: 0
    add_column :raw_material_stocks, :discount_amount, :decimal, default: 0
  end
end
