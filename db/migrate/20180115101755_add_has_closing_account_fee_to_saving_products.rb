class AddHasClosingAccountFeeToSavingProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :saving_products, :has_closing_account_fee, :boolean, default: :false
  end
end
