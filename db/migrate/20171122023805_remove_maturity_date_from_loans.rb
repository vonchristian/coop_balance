class RemoveMaturityDateFromLoans < ActiveRecord::Migration[5.1]
  def change
    remove_column :loans, :maturity_date, :datetime
  end
end
