class AddBorrowerFullNameToLoans < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :borrower_full_name, :string
  end
end
