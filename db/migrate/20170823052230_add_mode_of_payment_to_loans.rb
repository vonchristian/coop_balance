class AddModeOfPaymentToLoans < ActiveRecord::Migration[5.1]
  def change
    add_column :loans, :mode_of_payment, :integer
    add_index :loans, :mode_of_payment
  end
end
