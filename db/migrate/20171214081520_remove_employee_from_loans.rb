class RemoveEmployeeFromLoans < ActiveRecord::Migration[5.2]
  def change
    remove_reference :loans, :employee, foreign_key: { to_table: :users }
  end
end
