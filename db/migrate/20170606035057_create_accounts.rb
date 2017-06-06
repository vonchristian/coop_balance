class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :name
      t.string :code
      t.boolean :contra, default: false
      t.string :type

      t.timestamps
    end
    add_index :accounts, :name, unique: true
    add_index :accounts, :code, unique: true
    add_index :accounts, :type
  end
end
