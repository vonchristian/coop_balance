class AddBeneficiariesToTimeDepositsAndTimeDepositApplications < ActiveRecord::Migration[5.2]
  def change
  	add_column :time_deposits, :beneficiaries, :string
  	add_column :time_deposit_applications, :beneficiaries, :string
  end
end
