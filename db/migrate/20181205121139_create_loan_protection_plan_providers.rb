class CreateLoanProtectionPlanProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :loan_protection_plan_providers, id: :uuid do |t|
      t.string :business_name
      t.decimal :rate
      t.belongs_to :cooperative,      foreign_key: true, type: :uuid
      t.belongs_to :accounts_payable, foreign_key: { to_table: :accounts }, type: :uuid

      t.timestamps
    end
  end
end
