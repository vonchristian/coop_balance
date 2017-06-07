class CreateSavingProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :saving_products, id: :uuid do |t|
      t.string :name
      t.decimal :interest_rate
      t.integer :interest_recurrence

      t.timestamps
    end
    add_index :saving_products, :name, unique: true
  end
end
