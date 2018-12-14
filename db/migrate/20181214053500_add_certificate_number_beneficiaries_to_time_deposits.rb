class AddCertificateNumberBeneficiariesToTimeDeposits < ActiveRecord::Migration[5.2]
  def change
  	add_column :time_deposits, :certificate_number, :string
  	add_column :time_deposits, :beneficiaries, :string, array: true, default: '{}'
  end
end
