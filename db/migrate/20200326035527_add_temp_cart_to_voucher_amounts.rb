class AddTempCartToVoucherAmounts < ActiveRecord::Migration[6.0]
  def change
    add_reference :voucher_amounts, :temp_cart, polymorphic: true, type: :uuid 
  end
end
