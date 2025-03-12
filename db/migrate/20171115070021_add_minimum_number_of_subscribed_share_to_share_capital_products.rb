class AddMinimumNumberOfSubscribedShareToShareCapitalProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :share_capital_products, :minimum_number_of_subscribed_share, :decimal
    add_column :share_capital_products, :minimum_number_of_paid_share, :decimal
    add_column :share_capital_products, :default_product, :boolean, default: false
  end
end
