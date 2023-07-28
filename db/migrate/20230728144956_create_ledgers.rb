class CreateLedgers < ActiveRecord::Migration[6.1]
  def change
    create_table :ledgers, id: :uuid do |t|
      t.string :account_type, null: false 
      t.string :code, null: false 
      t.string :name, null: false
      t.boolean :contra, default: false 

      t.timestamps
    end
    add_index :ledgers, :account_type
    add_index :ledgers, :code
    add_index :ledgers, :contra
  end
end
