class AddCanEarnInterestToSavingProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :saving_products, :can_earn_interest, :boolean, default: false
  end
end
