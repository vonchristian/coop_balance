class AddCodeToLoans < ActiveRecord::Migration[5.2]
  def change
    add_column :loans, :code, :string
    add_index :loans, :code, unique: true
  end
end
