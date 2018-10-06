class RemoveUserFromVouchers < ActiveRecord::Migration[5.2]
  def change
    remove_reference :vouchers, :user, foreign_key: true
  end
end
