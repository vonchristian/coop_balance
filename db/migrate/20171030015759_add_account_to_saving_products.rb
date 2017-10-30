class AddAccountToSavingProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :saving_products, :account, foreign_key: true, type: :uuid
  end
end
