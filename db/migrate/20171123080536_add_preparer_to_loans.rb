class AddPreparerToLoans < ActiveRecord::Migration[5.1]
  def change
    add_reference :loans, :preparer, foreign_key: { to_table: :users }, type: :uuid
  end
end
