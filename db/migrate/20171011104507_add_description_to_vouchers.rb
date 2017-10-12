class AddDescriptionToVouchers < ActiveRecord::Migration[5.1]
  def change
    add_column :vouchers, :description, :string
  end
end
