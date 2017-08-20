class CreateModeOfPayments < ActiveRecord::Migration[5.1]
  def change
    create_table :mode_of_payments, id: :uuid do |t|
      t.integer :mode, index: true

      t.timestamps
    end
  end
end
