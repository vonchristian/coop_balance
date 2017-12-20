class CreateSavings < ActiveRecord::Migration[5.1]
  def change
    create_table :savings, id: :uuid do |t|
      t.belongs_to :member, foreign_key: true, type: :uuid
      t.string :account_number
      t.string :account_owner_name

      t.timestamps
    end
    add_index :savings, :account_number, unique: true
  end
end
