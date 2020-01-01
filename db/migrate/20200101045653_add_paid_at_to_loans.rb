class AddPaidAtToLoans < ActiveRecord::Migration[6.0]
  def change
    add_column :loans, :paid_at, :datetime
  end
end
