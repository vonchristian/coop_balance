class CreateLoanProtectionFunds < ActiveRecord::Migration[5.2]
  def change
    create_table :loan_protection_funds, id: :uuid do |t|
      t.string :rate
      t.string :name
      t.integer :computation_type
      t.belongs_to :cooperative, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index :loan_protection_funds, :computation_type
  end
end
