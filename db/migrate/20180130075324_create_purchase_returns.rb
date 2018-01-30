class CreatePurchaseReturns < ActiveRecord::Migration[5.2]
  def change
    create_table :purchase_returns, id: :uuid do |t|
      t.belongs_to :supplier, foreign_key: true, type: :uuid
      t.belongs_to :product_stock, foreign_key: true, type: :uuid
      t.decimal :quantity
      t.decimal :total_cost
      t.datetime :return_date

      t.timestamps
    end
  end
end
