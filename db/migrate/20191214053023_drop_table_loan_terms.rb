class DropTableLoanTerms < ActiveRecord::Migration[6.0]
  def up
    drop_table :loan_terms
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
