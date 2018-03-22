class AddSalesDiscountToStoreFronts < ActiveRecord::Migration[5.1]
  def change
    add_reference :store_fronts, :sales_discount_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
