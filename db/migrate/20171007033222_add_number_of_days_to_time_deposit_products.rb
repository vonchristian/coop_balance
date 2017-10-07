class AddNumberOfDaysToTimeDepositProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :time_deposit_products, :number_of_days, :integer
  end
end
