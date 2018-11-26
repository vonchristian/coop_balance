class AddPredeductedNumberOfPaymentsToInterestConfigs < ActiveRecord::Migration[5.2]
  def change
    add_column :interest_configs, :prededucted_number_of_payments, :integer
    add_column :interest_configs, :prededucted_amount, :decimal
  end
end
