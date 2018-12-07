class AddGracePeriodToLoanProducts < ActiveRecord::Migration[5.2]
  def change
  	add_column :loan_products, :grace_period, :decimal, default: 0.0
  end
end
