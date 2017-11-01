class CreateLoanProtectionProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_protection_providers, id: :uuid do |t|
      t.string :business_name
      t.string :adddress
      t.string :contact_number

      t.timestamps
    end
  end
end
