class AddPaymentTypeToEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :entries, :payment_type, :integer, default: 0
    add_index :entries, :payment_type
  end
end
