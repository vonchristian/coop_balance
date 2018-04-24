class RemoveTermFromLoans < ActiveRecord::Migration[5.2]
  def change
    remove_column :loans, :term, :integer
  end
end
