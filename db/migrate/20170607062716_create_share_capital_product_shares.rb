class CreateShareCapitalProductShares < ActiveRecord::Migration[5.1]
  def change
    create_table :share_capital_product_shares, id: :uuid do |t|
      t.belongs_to :share_capital_product, foreign_key: true, type: :uuid
      t.decimal :share_count
      t.decimal :cost_per_share
      t.datetime :date

      t.timestamps
    end
  end
end
