class RemoveTypeFromVouchers < ActiveRecord::Migration[5.2]
  def change
    remove_index :vouchers, :type
    
    remove_column :vouchers, :type, :string
    remove_reference :vouchers, :commercial_document, polymorphic: true, type: :uuid

  end
end
