class CreateCashCounts < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_counts, id: :uuid do |t|
      t.belongs_to :bill, foreign_key: true, type: :uuid
      t.decimal :quantity

      t.timestamps
    end
  end
end
