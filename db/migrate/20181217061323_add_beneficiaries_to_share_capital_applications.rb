class AddBeneficiariesToShareCapitalApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :share_capital_applications, :beneficiaries, :string
  end
end
