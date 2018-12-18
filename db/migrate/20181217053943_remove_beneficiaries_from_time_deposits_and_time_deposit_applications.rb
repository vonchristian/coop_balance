class RemoveBeneficiariesFromTimeDepositsAndTimeDepositApplications < ActiveRecord::Migration[5.2]
  def change
  	remove_column :time_deposits, :beneficiaries, :string, array: true
  	remove_column :time_deposit_applications, :beneficiaries, :string, array: true
  end
end
