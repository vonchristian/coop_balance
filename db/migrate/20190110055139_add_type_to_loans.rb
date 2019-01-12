class AddTypeToLoans < ActiveRecord::Migration[5.2]
  def change
    add_column :loans, :type, :string
    add_index :loans, :type
  end
end
