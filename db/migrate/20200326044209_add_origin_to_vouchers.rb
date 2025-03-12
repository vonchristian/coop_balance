class AddOriginToVouchers < ActiveRecord::Migration[6.0]
  def change
    add_reference :vouchers, :origin, polymorphic: true,  type: :uuid
  end
end
