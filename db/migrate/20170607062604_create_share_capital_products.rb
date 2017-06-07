class CreateShareCapitalProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :share_capital_products, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
    add_index :share_capital_products, :name
  end
end
