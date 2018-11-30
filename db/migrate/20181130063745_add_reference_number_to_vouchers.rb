class AddReferenceNumberToVouchers < ActiveRecord::Migration[5.2]
  def change
    add_column :vouchers, :reference_number, :string
  end
end
