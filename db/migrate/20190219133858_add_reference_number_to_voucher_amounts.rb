class AddReferenceNumberToVoucherAmounts < ActiveRecord::Migration[5.2]
  def change
    add_column :voucher_amounts, :reference_number, :string
  end
end
