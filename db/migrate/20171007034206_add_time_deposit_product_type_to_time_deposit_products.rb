class AddTimeDepositProductTypeToTimeDepositProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :time_deposit_products, :time_deposit_product_type, :integer
  end
end
