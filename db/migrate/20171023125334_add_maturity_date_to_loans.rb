class AddMaturityDateToLoans < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :maturity_date, :datetime
  end
end
