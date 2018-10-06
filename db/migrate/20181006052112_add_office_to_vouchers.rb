class AddOfficeToVouchers < ActiveRecord::Migration[5.2]
  def change
    add_reference :vouchers, :office, foreign_key: true, type: :uuid
    add_reference :vouchers, :cooperative, foreign_key: true, type: :uuid
  end
end
