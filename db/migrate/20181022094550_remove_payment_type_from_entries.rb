class RemovePaymentTypeFromEntries < ActiveRecord::Migration[5.2]
  def change
    remove_index :entries, :payment_type
    remove_column :entries, :payment_type, :integer
  end
end
