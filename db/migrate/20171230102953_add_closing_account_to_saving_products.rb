class AddClosingAccountToSavingProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :saving_products, :closing_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
