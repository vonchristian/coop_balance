class AddBeneficiariesToSavingsAccountsAndSavingsAccountsApplication < ActiveRecord::Migration[5.2]
  def change
  	add_column :savings_account_applications, :beneficiaries, :string
  end
end
