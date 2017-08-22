class AddTermToLoans < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :term, :decimal
  end
end
