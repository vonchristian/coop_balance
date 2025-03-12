class AddCertificateNumberAndBeneficiariesToTimeDepositApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :time_deposit_applications, :certificate_number, :string
    add_column :time_deposit_applications, :beneficiaries, :string, array: true, default: '{}'
  end
end
