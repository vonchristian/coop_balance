class CreateUtilityBillCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :utility_bill_categories, id: :uuid do |t|
      t.string :title

      t.timestamps
    end
    add_index :utility_bill_categories, :title, unique: true
  end
end
