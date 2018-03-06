class AddDisbursementDateToLoans < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :disbursement_date, :datetime
  end
end
