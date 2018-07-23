class CreateAccountBudgets < ActiveRecord::Migration[5.2]
  def change
    create_table :account_budgets, id: :uuid do |t|
      t.belongs_to :account, foreign_key: true, type: :uuid
      t.decimal :proposed_amount
      t.integer :year
      t.belongs_to :cooperative, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
