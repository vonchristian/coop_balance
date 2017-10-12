class AddUserToVouchers < ActiveRecord::Migration[5.1]
  def change
    add_reference :vouchers, :user, foreign_key: true, type: :uuid
  end
end
