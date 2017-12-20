class CreateLoanProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_products, id: :uuid do |t|
      t.string :name
      t.string :description
      t.string :interest_rate
      t.integer :interest_recurrence
      t.decimal :maximum_loanable_amount
      t.belongs_to :account, foreign_key: { to_table: :accounts }, type: :uuid
      t.belongs_to :interest_account, foreign_key: { to_table: :accounts }, type: :uuid
      t.belongs_to :penalty_account, foreign_key: { to_table: :accounts }, type: :uuid


      t.timestamps
    end
    add_index :loan_products, :interest_recurrence
  end
end
