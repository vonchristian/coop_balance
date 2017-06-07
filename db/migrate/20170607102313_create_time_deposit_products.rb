class CreateTimeDepositProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :time_deposit_products, id: :uuid do |t|
      t.decimal :minimum_amount
      t.decimal :maximum_amount
      t.decimal :interest_rate
      t.string :name
      t.integer :interest_recurrence

      t.timestamps
    end
    add_index :time_deposit_products, :name, unique: true
  end
end
