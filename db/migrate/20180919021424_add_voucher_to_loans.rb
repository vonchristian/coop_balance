class AddVoucherToLoans < ActiveRecord::Migration[5.2]
  def change
    add_reference :loans, :voucher, foreign_key: true, type: :uuid
  end
end
