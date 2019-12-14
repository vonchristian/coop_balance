class AddNumberOfDaysToTimeDepositApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :time_deposit_applications, :number_of_days, :integer
  end
end
