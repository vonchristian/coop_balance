class AddBeneficiariesToSavingsDeposits < ActiveRecord::Migration[5.2]
  def change
    add_column :savings, :beneficiaries, :string
  end
end
