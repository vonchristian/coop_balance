class CreateShareCapitals < ActiveRecord::Migration[5.1]
  def change
    create_table :share_capitals, id: :uuid do |t|
      t.belongs_to :member, foreign_key: true, type: :uuid
      t.belongs_to :share_capital_product, foreign_key: true, type: :uuid

      t.string :account_number
      t.datetime :date_opened
      t.string :type, index: true
    end
    add_index :share_capitals, :account_number, unique: true
  end
end
