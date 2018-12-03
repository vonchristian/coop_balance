class AddStatusToLoans < ActiveRecord::Migration[5.2]
  def change
    add_column :loans, :status, :integer
    add_index :loans, :status
  end
end
