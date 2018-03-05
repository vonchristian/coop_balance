class AddNumberOfDaysDormantToSavingsAccountConfigs < ActiveRecord::Migration[5.1]
  def change
    add_column :savings_account_configs, :number_of_days_to_be_dormant, :decimal
  end
end
