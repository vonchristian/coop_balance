class AddBranchTypeToBranchOffices < ActiveRecord::Migration[5.1]
  def change
    add_column :branch_offices, :branch_type, :integer
    add_index :branch_offices, :branch_type
  end
end
