class RemoveMaturityDatesFromLoans < ActiveRecord::Migration[5.2]
  def change
    remove_column :loans, :maturity_date, :datetime
  end
end
