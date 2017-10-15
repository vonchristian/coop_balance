class AddDescriptionToVoucherAmounts < ActiveRecord::Migration[5.1]
  def change
    add_column :voucher_amounts, :description, :string
  end
end
