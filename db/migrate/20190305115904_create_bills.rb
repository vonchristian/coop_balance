class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills, id: :uuid do |t|
      t.decimal :bill_amount
      t.string :name

      t.timestamps
    end
  end
end
