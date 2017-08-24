class CreateLoanProtectionRates < ActiveRecord::Migration[5.1]
  def change
    create_table :loan_protection_rates, id: :uuid do |t|
      t.decimal :term
      t.decimal :min_age
      t.decimal :max_age
      t.decimal :rate

      t.timestamps
    end
  end
end
