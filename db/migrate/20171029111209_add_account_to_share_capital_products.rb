class AddAccountToShareCapitalProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :share_capital_products, :account, foreign_key: true, type: :uuid
  end
end
