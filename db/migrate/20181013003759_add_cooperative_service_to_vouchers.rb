class AddCooperativeServiceToVouchers < ActiveRecord::Migration[5.2]
  def change
    add_reference :vouchers, :cooperative_service, foreign_key: true, type: :uuid
  end
end
