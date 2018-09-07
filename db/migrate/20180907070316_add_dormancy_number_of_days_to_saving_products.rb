class AddDormancyNumberOfDaysToSavingProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :saving_products, :dormancy_number_of_days, :integer, default: 0
  end
end
