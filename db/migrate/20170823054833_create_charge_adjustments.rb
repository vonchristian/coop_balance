class CreateChargeAdjustments < ActiveRecord::Migration[5.1]
  def change
    create_table :charge_adjustments, id: :uuid do |t|
      t.belongs_to :loan_charge, foreign_key: true, type: :uuid
      t.decimal :amount
      t.decimal :percent
      t.boolean :amortize_balance, default: false

      t.timestamps
    end
  end
end
