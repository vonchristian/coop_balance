class CreateLoanProtectionPlanProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :loan_protection_plan_providers, id: :uuid do |t|
      t.string :name
      t.belongs_to :account, foreign_key: true, type: :uuid
      t.decimal :rate

      t.timestamps
    end
  end
end
