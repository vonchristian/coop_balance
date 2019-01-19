class AddPayableAccountToSuppliers < ActiveRecord::Migration[5.2]
  def change
    add_reference :suppliers, :payable_account, foreign_key: { to_table: :accounts }, type: :uuid
  end
end
